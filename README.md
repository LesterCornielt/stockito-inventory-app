# Stockito

> ⚠️ **Não é o seu idioma?**
>
> Este README está em português. Se preferir outro idioma, troque para o branch correspondente:
> - Espanhol: `main`
> - Inglês: `docs/english-readme`

**Status atual:** v1.0.0

Stockito é um aplicativo de inventário e vendas desenvolvido em Flutter, pensado para pequenos negócios e empreendedores. Permite gerenciar produtos, registrar vendas e visualizar relatórios diários de forma simples e eficiente. Além disso, é altamente personalizável para se adaptar às necessidades específicas do seu negócio. Você pode adicionar uma funcionalidade específica na tela your_feature conforme os requisitos do seu empreendimento.

---

## 📱 Principais Funcionalidades

### 1. Gestão de Produtos
- Cadastro, edição e exclusão de produtos
- Busca rápida por nome
- Visualização de estoque e preços

<p>
  <img src="screenshots/light_mode_português/main_page.jpg" alt="Gestão de produtos" width="150"/>
  <img src="screenshots/light_mode_português/search_bar.jpg" alt="Barra de busca" width="150"/>
</p>

### 2. Relatórios de Vendas
- Página dedicada a relatórios diários (aba "Relatórios")
- Visualização de vendas por dia e seletor de data
- Resumo diário: total de produtos vendidos e valor total
- Lista detalhada de produtos vendidos
- Tratamento de estados vazios e erros

<p>
  <img src="screenshots/light_mode_português/sales_page.jpg" alt="Relatórios de vendas" width="150"/>
</p>

### 3. Configurações e Experiência do Usuário
- Banco de dados local SQLite
- Navegação e estado persistente entre sessões
- Interface moderna e responsiva
- Suporte multilíngue (espanhol, inglês, português)
- Modo escuro disponível em todas as funcionalidades

<p>
  <img src="screenshots/light_mode_português/settings_page.jpg" alt="Página de configurações" width="150"/>
</p>

### 4. Personalização e Extensibilidade
- O aplicativo foi projetado para ser facilmente personalizável.
- Você pode adicionar qualquer funcionalidade extra na tela "Sua Funcionalidade" (`your_feature`).
- Ideal para desenvolvedores que desejam adaptar o app para necessidades específicas ou experimentar novas funcionalidades.

<p>
  <img src="screenshots/light_mode_português/your_feature_page.jpg" alt="Sua Funcionalidade Claro" width="150"/>
</p>

---

## 🛠️ Tecnologias e Arquitetura

- **Framework:** Flutter
- **Gerenciamento de estado:** BLoC (flutter_bloc)
- **Injeção de dependências:** GetIt
- **Banco de dados local:** SQLite (sqflite)
- **Internacionalização:** flutter_localizations, arquivos JSON
- **Arquitetura:** Clean Architecture

---

## 🚀 Instalação e Execução

1. Baixe a versão mais recente do APK em [Releases](https://github.com/LesterCornielt/stockito-inventory-app/releases/download/v1.0.0/Stockito.v1.0.0.apk).
2. Instale no seu dispositivo Android.
3. Ou, siga estes passos para compilar a partir do código-fonte:
   ```sh
   git clone https://github.com/LesterCornielt/stockito-inventory-app.git
   cd stockito-inventory-app
   ```
4. Instale as dependências:
   ```sh
   flutter pub get
   ```
5. Execute o app:
   ```sh
   flutter run
   ```

---

## 📂 Estrutura do Projeto

- `lib/core/` - Serviços base, utilitários e configuração de dependências
- `lib/features/` - Funcionalidades principais (produtos, vendas, relatórios, configurações)
- `lib/l10n/` - Arquivos de localização
- `assets/` - Recursos gráficos
- `screenshots/` - Capturas de tela

Arquitetura baseada em Clean Architecture, separando dados, domínio e apresentação para facilitar a manutenção e escalabilidade.

---

## 🧪 Testes

O Stockito inclui uma suíte completa de testes automatizados seguindo as melhores práticas do Flutter e Clean Architecture.

### Tipos de Testes

#### 1. **Testes Unitários**
- **Cobertura**: Casos de uso, entidades, modelos, repositórios, fontes de dados
- **Localização**: `test/unit/`
- **Status**: ✅ Implementado
  - Camada de Domínio: Casos de uso e entidades (56 testes)
  - Camada de Dados: Modelos e repositórios (36 testes)

#### 2. **Testes de Widgets**
- **Cobertura**: Páginas, widgets personalizados, interação com BLoC
- **Localização**: `test/widget/`
- **Status**: ✅ Implementado

#### 3. **Testes de Integração**
- **Cobertura**: Fluxos completos end-to-end
- **Localização**: `integration_test/`
- **Status**: 📋 Planejado

### Executar Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Executar testes de uma feature específica
flutter test test/unit/features/products/

# Executar um teste específico
flutter test test/unit/features/products/domain/entities/product_test.dart
```

### Ver Cobertura de Código

```bash
# Gerar relatório HTML de cobertura
genhtml coverage/lcov.info -o coverage/html

# Abrir no navegador
xdg-open coverage/html/index.html  # Linux
open coverage/html/index.html      # macOS
```

### Estrutura de Testes

```
test/
├── unit/                          # Testes unitários
│   ├── features/
│   │   ├── products/
│   │   │   ├── domain/           # Casos de uso e entidades
│   │   │   └── data/             # Modelos e repositórios
│   │   └── sales/
│   │       ├── domain/
│   │       └── data/
│   └── core/                      # Testes de serviços base
├── widget/                        # Testes de widgets
│   └── features/
│       ├── products/
│       ├── sales/
│       ├── navigation/
│       └── settings/
├── helpers/                       # Helpers e utilitários
│   ├── mock_data.dart            # Dados de teste reutilizáveis
│   ├── test_helpers.dart         # Funções auxiliares
│   ├── bloc_test_helpers.dart   # Helpers para BLoC
│   └── widget_test_helpers.dart # Helpers para testes de widgets
└── integration_test/              # Testes de integração
```

### Ferramentas e Dependências

As seguintes ferramentas são usadas para testes:

- **flutter_test**: Framework de testes do Flutter (incluído no SDK)
- **bloc_test**: Testes de BLoCs e gerenciamento de estado
- **mockito**: Criação de mocks para dependências
- **sqflite_common_ffi**: Banco de dados em memória para testes em desktop
- **fake_async**: Controle de tempo em testes assíncronos

### Helpers Disponíveis

O projeto inclui helpers reutilizáveis para facilitar a escrita de testes:

- **MockData**: Dados de teste predefinidos (produtos, vendas)
- **TestHelpers**: Funções para configurar banco de dados de teste
- **BlocTestHelpers**: Utilitários específicos para testes de BLoC
- **WidgetTestHelpers**: Helpers para configuração de testes de widgets

### Documentação Adicional

Para mais informações sobre testes, consulte:
- [`test/README.md`](test/README.md) - Guia completo de testes
- [`plan.md`](plan.md) - Plano de implementação de testes
- [`test/EJECUTAR_TESTS.md`](test/EJECUTAR_TESTS.md) - Guia detalhado de execução

---

## 🤝 Como Contribuir?

Contribuições são bem-vindas! Para colaborar:

1. Faça um fork do repositório e clone localmente.
2. Crie um branch para sua feature ou correção:
   ```sh
   git checkout -b minha-feature
   ```
3. Faça suas alterações e commits descritivos.
4. Certifique-se de que o app compila e segue as boas práticas do projeto.
5. Faça push para seu fork e abra um Pull Request para `main`.
6. Descreva claramente sua contribuição no PR.

**Recomendações:**
- Siga a arquitetura e os padrões existentes (Clean Architecture, BLoC, etc).

---

## 📝 Licença

Licença MIT. Consulte o arquivo LICENSE para mais detalhes.

