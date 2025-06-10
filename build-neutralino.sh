#!/bin/bash

echo "🚀 Build Neutralino.js com Docker..."
echo "🧹 Limpando builds anteriores..."
rm -rf dist/

# Executar build
echo "🔨 Executando build com Docker..."
docker-compose up --build

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