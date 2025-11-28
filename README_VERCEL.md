# Deploy na Vercel - Prestou

## Passos para fazer deploy:

### 1. Preparar o repositório Git

```bash
git init
git add .
git commit -m "Initial commit"
```

### 2. Subir para GitHub

1. Crie um repositório no GitHub
2. Execute:

```bash
git remote add origin https://github.com/SEU_USUARIO/prestou.git
git branch -M main
git push -u origin main
```

### 3. Deploy na Vercel

#### Opção A: Via Dashboard (Recomendado)

1. Acesse [vercel.com](https://vercel.com)
2. Faça login com sua conta GitHub
3. Clique em "Add New Project"
4. Selecione seu repositório `prestou`
5. A Vercel detectará automaticamente as configurações do `vercel.json`
6. Clique em "Deploy"

#### Opção B: Via CLI

```bash
npm install -g vercel
vercel login
vercel
```

### 4. Configurações importantes

- **Build Command**: `flutter build web --release --web-renderer canvaskit`
- **Output Directory**: `build/web`
- **Install Command**: Configurado automaticamente no `vercel.json`

### 5. Variáveis de ambiente (se necessário)

Se você usar variáveis de ambiente:

1. No dashboard da Vercel, vá em Settings > Environment Variables
2. Adicione suas variáveis (ex: API_URL, API_KEY, etc.)
3. Faça redeploy do projeto

### 6. Build local (teste antes do deploy)

```bash
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
```

### Notas:

- O `vercel.json` já está configurado para SPA (Single Page Application)
- Todas as rotas serão redirecionadas para `index.html`
- O `usePathUrlStrategy()` no `main.dart` garante URLs limpas (sem #)
- Certifique-se de ter espaço em disco suficiente antes do build

### Troubleshooting:

Se o deploy falhar:
1. Verifique os logs no dashboard da Vercel
2. Execute `flutter clean` e tente novamente
3. Verifique se todas as dependências são compatíveis com web
4. Teste o build localmente primeiro
