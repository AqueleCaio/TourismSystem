import { PrismaClient } from '@prisma/client';
import axios from 'axios';

const prisma = new PrismaClient();

async function fetchWorldBankData(indicatorId: string) {
  const baseUrl = `https://api.worldbank.org/v2/country/all/indicator/${indicatorId}?format=json&per_page=17290`;
  let allData: any[] = [];
  let page = 1;
  let totalPages = 1;

  while (page <= totalPages) {
    const url = `${baseUrl}&page=${page}`;
    const response = await axios.get(url);
    const metadata = response.data[0];
    const data = response.data[1];

    if (page === 1) {
      totalPages = metadata.pages; // pega o número total de páginas
    }

    if (data) {
      allData.push(...data);
    }

    page++;
  }

  return allData;
}


// Função para validar e formatar o iso3code
function getValidIso3code(code: string): string | null {
  return code && code.length === 3 ? code : 'XXX'; // Usar 'XXX' como valor padrão para códigos inválidos
}

async function main() {
  // 1. Criar o indicador de turismo
  await prisma.indicator.upsert({
    where: { id: 'ST.INT.ARVL' },
    update: {},
    create: {
      id: 'ST.INT.ARVL',
      name: 'International tourism, number of arrivals'
    }
  });

  // 2. Buscar dados da API
  const apiData = await fetchWorldBankData('ST.INT.ARVL');
  console.log(`Found ${apiData.length} records from World Bank API`);

  // 3. Processar e inserir dados
  for (const item of apiData) {
    if (!item.country || !item.country.id || !item.date) continue;

    // Pular códigos de país inválidos (como "XM")
    if (!getValidIso3code(item.country.id)) {
      console.log(`Skipping invalid country code: ${item.country.id}`);
      continue;
    }

    try {
      // Verificar se o iso3code é válido antes de usar
      // Dentro do loop principal, modifique a criação do país:
      const iso3code = getValidIso3code(item.countryiso3code);

      // Ignora países com código inválido ou que são 'XXX'
      if (iso3code === 'XXX') {
        continue;
      }

      await prisma.country.upsert({
        where: { id: item.country.id },
        update: {
          name: item.country.value,
          ...(iso3code && { iso3code }) // Atualiza iso3code apenas se existir
        },
        create: {
          id: item.country.id,
          name: item.country.value,
          iso3code: iso3code || 'XXX' // Valor padrão para códigos inválidos
        }
      });

      // Inserir dados de turismo (apenas se houver valor)
      if (item.value !== null) {
        await prisma.tourismData.upsert({
          where: {
            country_year_indicator: {
              country_id: item.country.id,
              year: parseInt(item.date),
              indicator_id: 'ST.INT.ARVL'
            }
          },
          update: {
            value: item.value,
            unit: item.unit || '0',
            obs_status: item.obs_status || '0',
            decimal: item.decimal || 0
          },
          create: {
            country_id: item.country.id,
            year: parseInt(item.date),
            indicator_id: 'ST.INT.ARVL',
            value: item.value,
            unit: item.unit || '0',
            obs_status: item.obs_status || '0',
            decimal: item.decimal || 0
          }
        });
      }
    } catch (error) {
      console.error(`Error processing country ${item.country.id} year ${item.date}:`, error);
    }
  }

  console.log('Seed completed successfully!');
}

main()
  .catch(e => {
    console.error('Error during seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });