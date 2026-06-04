"""
Script para remover fundo das imagens do Bolt
Usa rembg (remove background) automaticamente
"""

import os
from pathlib import Path

try:
    from rembg import remove
    from PIL import Image
except ImportError:
    print("❌ Instalando dependências necessárias...")
    print("Execute: pip install rembg pillow")
    print("\nDepois execute novamente: python remove_background.py")
    exit(1)

# Caminhos
ORIGEM = Path("assets/bolt/fotos-boratreinar")
DESTINO_EXPRESSIONS = Path("assets/bolt/expressions")
DESTINO_LEAGUES = Path("assets/bolt/leagues")

# Mapeamento de nomes
MAPEAMENTO_EXPRESSIONS = {
    "ready.png": "ready.png",
    "feliz.png": "happy.png",
    "animado.png": "excited.png",
    "Conquista.png": "trophy.png",
    "cansado.png": "sleeping.png",
    "pensando.png": "cool.png",
    "comemorando.png": "fire.png",  # da pasta ações
}

MAPEAMENTO_LEAGUES = {
    "bronze.png": "bronze.png",
    "prata.png": "silver.png",
    "ouro.png": "gold.png",
    "Diamante.png": "diamond.png",
    "lendario.png": "legendary.png",
}

def remove_background(input_path, output_path):
    """Remove fundo de uma imagem"""
    print(f"  Processando: {input_path.name}")
    
    try:
        # Abrir imagem
        input_image = Image.open(input_path)
        
        # Remover fundo
        output_image = remove(input_image)
        
        # Salvar como PNG
        output_image.save(output_path, 'PNG')
        print(f"  ✅ Salvo: {output_path.name}")
        
    except Exception as e:
        print(f"  ❌ Erro: {e}")

def processar_expressions():
    """Processa imagens de expressões"""
    print("\n📸 Processando EXPRESSÕES...")
    DESTINO_EXPRESSIONS.mkdir(parents=True, exist_ok=True)
    
    for nome_origem, nome_destino in MAPEAMENTO_EXPRESSIONS.items():
        # Tentar encontrar em diferentes pastas
        possíveis_caminhos = [
            ORIGEM / nome_origem,
            ORIGEM / "Expressões" / nome_origem,
            ORIGEM / "ações" / nome_origem,
        ]
        
        for caminho in possíveis_caminhos:
            if caminho.exists():
                output_path = DESTINO_EXPRESSIONS / nome_destino
                remove_background(caminho, output_path)
                break
        else:
            print(f"  ⚠️  Não encontrado: {nome_origem}")

def processar_leagues():
    """Processa imagens de ligas"""
    print("\n🏆 Processando LIGAS...")
    DESTINO_LEAGUES.mkdir(parents=True, exist_ok=True)
    
    pasta_evolucao = ORIGEM / "evolucao"
    
    for nome_origem, nome_destino in MAPEAMENTO_LEAGUES.items():
        caminho = pasta_evolucao / nome_origem
        
        if caminho.exists():
            output_path = DESTINO_LEAGUES / nome_destino
            remove_background(caminho, output_path)
        else:
            print(f"  ⚠️  Não encontrado: {nome_origem}")

def main():
    print("=" * 60)
    print("🎨 REMOVEDOR DE FUNDO - BOLT")
    print("=" * 60)
    
    if not ORIGEM.exists():
        print(f"❌ Pasta não encontrada: {ORIGEM}")
        return
    
    print(f"✅ Pasta origem: {ORIGEM}")
    print(f"✅ Destino expressões: {DESTINO_EXPRESSIONS}")
    print(f"✅ Destino ligas: {DESTINO_LEAGUES}")
    
    # Processar
    processar_expressions()
    processar_leagues()
    
    print("\n" + "=" * 60)
    print("✅ CONCLUÍDO!")
    print("=" * 60)
    print("\n📋 Próximos passos:")
    print("1. Verifique as imagens em assets/bolt/expressions/")
    print("2. Verifique as imagens em assets/bolt/leagues/")
    print("3. Execute: flutter pub get")
    print("4. Execute: flutter build web --release")
    print("5. Execute: firebase deploy --only hosting")

if __name__ == "__main__":
    main()
