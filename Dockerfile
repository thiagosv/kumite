# Dockerfile para build do Neutralino.js
FROM node:18-bullseye

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho
WORKDIR /app

# Instalar Neutralino CLI
RUN npm install -g @neutralinojs/neu

# Copiar arquivos de configuração primeiro
COPY neutralino.config.json ./

# Inicializar projeto se necessário
RUN neu update

# Copiar recursos
COPY resources/ ./resources/

# Verificar se os arquivos foram copiados
RUN echo "=== Verificando arquivos ===" && \
    ls -la && \
    echo "=== Conteúdo resources ===" && \
    ls -la resources/ && \
    echo "=== Conteúdo bin ===" && \
    ls -la bin/ || echo "Pasta bin não existe ainda"

# Fazer build
RUN neu build

# Verificar resultado
RUN echo "=== Resultado do build ===" && \
    ls -la dist/ && \
    echo "=== Tamanhos ===" && \
    du -h dist/* || echo "Nenhum arquivo gerado"

# Criar volume de saída
VOLUME ["/app/dist"]

# Comando padrão
CMD ["sh", "-c", "ls -la dist/ && cp -r dist/* /output/ 2>/dev/null || echo 'Nenhum arquivo para copiar'"]