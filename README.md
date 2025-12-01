# Prestou App

App Flutter para a plataforma Prestou - Sistema de anúncios e prestação de serviços.

## 🚀 Funcionalidades

- ✅ Autenticação (Login, Registro, Recuperação de senha)
- ✅ Gestão de Anúncios (Criar, Listar, Visualizar)
- ✅ Categorias de Anúncios
- ✅ Dashboard
- ✅ Perfil de Usuário
- 🔄 Upload de Imagens (Em desenvolvimento)

## 📋 Pré-requisitos

- Flutter SDK 3.27.0+
- Dart SDK 3.6.0+

## 🔧 Instalação

```bash
# Clone o repositório
git clone https://github.com/Prestou/app.git

# Entre no diretório
cd app

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

## 🌐 Ambientes

### Development
```bash
# Configurado em lib/app/config/env_dev.dart
flutter run --dart-define=ENV=dev
```

### Production
```bash
# Configurado em lib/app/config/env_prd.dart
flutter run --dart-define=ENV=prd
```

## 📱 Plataformas Suportadas

- ✅ Web
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ Linux
- ✅ macOS

## 🏗️ Estrutura do Projeto

```
lib/
├── app/
│   ├── config/          # Configurações (tema, cores, env)
│   ├── core/            # Serviços core (dio, router)
│   ├── features/        # Funcionalidades do app
│   │   ├── auth/        # Autenticação
│   │   ├── advertisements/  # Anúncios
│   │   ├── dashboard/   # Dashboard
│   │   ├── home/        # Home
│   │   └── profile/     # Perfil
│   ├── settings/        # Configurações do app
│   └── widgets/         # Widgets reutilizáveis
└── main.dart
```

## 🔗 API

API Base URL: `https://api.prestou.com`

Documentação: [https://api.prestou.com/docs](https://api.prestou.com/docs)

## 📦 Dependências Principais

- `flutter_bloc` - Gerenciamento de estado
- `go_router` - Navegação
- `dio` - Cliente HTTP
- `shared_preferences` - Armazenamento local

## 🚀 Deploy

### GitHub Pages
O app está configurado para deploy automático no GitHub Pages via GitHub Actions.

URL: [https://prestou.github.io/app/](https://prestou.github.io/app/)

## 👥 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

## 📞 Contato

Prestou - [https://prestou.com](https://prestou.com)

Link do Projeto: [https://github.com/Prestou/app](https://github.com/Prestou/app)

