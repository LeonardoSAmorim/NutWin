# NutWin - Preservação e Manutenção 🛠️

## Sobre o Projeto
Este repositório é um *fork* de preservação e continuação do **NutWin**, um software de cálculo e organização nutricional desenvolvido originalmente na **Escola Paulista de Medicina da Universidade Federal de São Paulo (Unifesp)**. 

O objetivo do NutWin é auxiliar o nutricionista na realização de cálculos para Avaliação Nutricional, quantificação de ingestão de nutrientes e elaboração de planos alimentares. O software original foi escrito em **Delphi** e mantido historicamente no [SourceForge](https://sourceforge.net/projects/nutwin/).

**Contexto Histórico:** O software foi comercializado com grande sucesso pela universidade até o início dos anos 2000. Em 2014, sem recursos para manter a equipe de suporte e desenvolvimento, o projeto foi abandonado. O mantenedor original, Paulo Bandiera Paiva, declarou o software como de domínio público com o apelo de que desenvolvedores da comunidade assumissem a missão de modernizar o banco de dados e dar suporte ao sistema. 

A missão deste repositório retoma exatamente esse propósito original, garantindo que o código, sua documentação e seus bancos de dados não se percam no tempo, mantendo-os funcionais e acessíveis.

## Interface Original

| Tela Inicial | Organizador |
| :---: | :---: |
| ![Cover](https://a.fsdn.com/con/app/proj/nutwin/screenshots/259874.jpg/max/max/1) | ![Organizador](https://a.fsdn.com/con/app/proj/nutwin/screenshots/259876.jpg/max/max/1) |
| **Calculadora** | **Antropometria** |
| ![Calculadora](https://a.fsdn.com/con/app/proj/nutwin/screenshots/259878.jpg/max/max/1) | ![Antropometria](https://a.fsdn.com/con/app/proj/nutwin/screenshots/259880.jpg/max/max/1) |

## Funcionalidades Originais Preservadas
O sistema conta com as seguintes ferramentas validadas:
* Planos Alimentares com Equivalentes Protéicos e de Energia.
* Inquéritos alimentares.
* Cálculos Antropométricos abrangentes (Crianças, Adolescentes, Adultos, Idosos, Gestantes, Nutrizes e Deficientes Físicos).
* Cálculo de nutrientes de uma receita.
* Alimentos quantificados em medidas caseiras.

## 🔐 Acesso ao Sistema (Credenciais Padrão)
Para acessar a interface do programa após a compilação ou ao utilizar os instaladores originais preservados, utilize as credenciais de fábrica:
* **Usuário:** `SUPERVISOR`
* **Senha:** `NUT`

## Escopo de Contribuição
Este projeto é aberto ao público e mantido pela comunidade. O escopo de desenvolvimento atual é **estritamente focado em**:
1. Correção de *bugs* e instabilidades estruturais do código legado.
2. Adaptações e atualizações necessárias para que o sistema compile e execute adequadamente nos sistemas operacionais e plataformas modernas.

⚠️ **Nota:** Não há intenção de adicionar novas funcionalidades ao software. A meta é preservar a essência, as regras de negócio e as ferramentas originais. *Pull Requests* voltados à manutenção, estabilidade e compatibilidade são muito bem-vindos.

## Estrutura do Repositório
* **Código-Fonte:** A ramificação principal (`main`) contém o histórico completo extraído do SVN original, sendo o palco para atualizações de manutenção.
* **Lançamentos Originais (Releases):** Os instaladores finais, manuais de ajuda originais compilados (`Organiza.chm`, `Calculo.chm`) e pacotes distribuídos na época (como a v1.6 e v1.5.2.51) estão preservados e isolados na aba **[Releases](../../releases)** para fins históricos e de consulta.

## Créditos e Licença
A arquitetura, o design e as diretrizes de cálculo nutricional pertencem aos desenvolvedores e pesquisadores originais da Unifesp. 

**Licença:** Conforme declarado oficialmente pelo mantenedor do projeto em 2014, o NutWin foi colocado em **Domínio Público**. Este repositório dá continuidade ao código-fonte público original e mantém esse espírito de acesso livre e colaborativo.