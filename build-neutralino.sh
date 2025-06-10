#!/bin/bash

echo "🚀 Build Neutralino.js com Docker..."

# Verificar arquivos necessários
echo "📋 Verificando arquivos necessários..."

if [ ! -f "neutralino.config.json" ]; then
    echo "❌ neutralino.config.json não encontrado!"
    echo "Criando arquivo padrão..."

    cat > neutralino.config.json << 'EOF'
{
  "applicationId": "com.example.minha-app-html",
  "version": "1.0.0",
  "defaultMode": "window",
  "port": 0,
  "documentRoot": "/resources/",
  "url": "/",
  "nativeAllowList": [
    "app.*",
    "window.*"
  ],
  "modes": {
    "window": {
      "title": "Minha App HTML",
      "width": 1200,
      "height": 800,
      "resizable": true,
      "exitProcessOnClose": true
    }
  },
  "cli": {
    "binaryName": "minha-app-html",
    "resourcesPath": "/resources/",
    "binaryVersion": "4.14.1",
    "clientVersion": "3.12.0"
  }
}
EOF
fi

if [ ! -d "resources" ]; then
    echo "📁 Criando diretório resources..."
    mkdir -p resources
fi

if [ ! -f "resources/index.html" ]; then
    echo "❌ resources/index.html não encontrado!"
    echo "Criando HTML de exemplo..."

    cat > resources/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Minha App HTML</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Olá Mundo!</h1>
    <p>Substitua este arquivo pelo seu HTML de 400KB</p>
    <script src="js/neutralino.js"></script>
    <script>
        Neutralino.init();
    </script>
</body>
</html>
EOF
    echo "⚠️  Substitua resources/index.html pelo seu arquivo HTML!"
fi

# Limpar builds anteriores
echo "🧹 Limpando builds anteriores..."
rm -rf dist/

# Executar build
echo "🔨 Executando build com Docker..."
docker-compose up --build neutralino-builder

# Verificar resultado
if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
    echo "✅ Build concluído com sucesso!"
    echo "📦 Arquivos gerados:"
    ls -lh dist/

    echo ""
    echo "📊 Tamanhos:"
    for file in dist/*; do
        if [ -f "$file" ]; then
            size=$(du -h "$file" | cut -f1)
            echo "  $(basename "$file"): $size"
        fi
    done
else
    echo "❌ Nenhum arquivo foi gerado!"
    echo "🔍 Verificando logs..."
    docker-compose logs neutralino-builder
fi

# Limpar containers
echo "🧹 Limpando containers..."
docker-compose down

echo "🎉 Processo concluído!"