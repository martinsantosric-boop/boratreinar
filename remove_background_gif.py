#!/usr/bin/env python3
"""
Script para remover fundo de GIFs animados
Processa frame por frame e mantém transparência
"""

from PIL import Image
from rembg import remove
import os

def remove_gif_background(input_path, output_path):
    """
    Remove o fundo de um GIF animado frame por frame
    
    Args:
        input_path: Caminho do GIF original
        output_path: Caminho para salvar GIF sem fundo
    """
    print(f"=" * 60)
    print(f"🎬 REMOVEDOR DE FUNDO DE GIF")
    print(f"=" * 60)
    print(f"📂 Arquivo de entrada: {input_path}")
    print(f"💾 Arquivo de saída: {output_path}")
    print()
    
    # Abrir o GIF
    try:
        gif = Image.open(input_path)
    except Exception as e:
        print(f"❌ Erro ao abrir arquivo: {e}")
        return False
    
    # Verificar se é animado
    try:
        n_frames = gif.n_frames
        print(f"📊 Total de frames: {n_frames}")
    except AttributeError:
        n_frames = 1
        print(f"⚠️  GIF não é animado (apenas 1 frame)")
    
    # Processar cada frame
    frames = []
    durations = []
    
    for frame_num in range(n_frames):
        gif.seek(frame_num)
        frame = gif.convert('RGBA')
        
        print(f"🔄 Processando frame {frame_num + 1}/{n_frames}...", end=' ')
        
        # Remover fundo do frame
        try:
            frame_no_bg = remove(frame)
            frames.append(frame_no_bg)
            
            # Tentar obter duração do frame
            try:
                duration = gif.info.get('duration', 100)
                durations.append(duration)
            except:
                durations.append(100)  # Duração padrão
            
            print("✅")
        except Exception as e:
            print(f"❌ Erro: {e}")
            return False
    
    # Salvar novo GIF
    print()
    print(f"💾 Salvando GIF sem fundo...")
    
    try:
        frames[0].save(
            output_path,
            save_all=True,
            append_images=frames[1:],
            duration=durations,
            loop=0,  # Loop infinito
            transparency=0,
            disposal=2,
            optimize=False  # Não otimizar para manter qualidade
        )
        print(f"✅ GIF salvo com sucesso!")
        print()
        
        # Mostrar tamanhos
        input_size = os.path.getsize(input_path)
        output_size = os.path.getsize(output_path)
        
        print(f"📊 Tamanho original: {input_size / 1024:.2f} KB")
        print(f"📊 Tamanho novo: {output_size / 1024:.2f} KB")
        
        if output_size > input_size:
            diff = ((output_size - input_size) / input_size) * 100
            print(f"⚠️  Aumentou {diff:.1f}% (normal para GIFs com transparência)")
        else:
            diff = ((input_size - output_size) / input_size) * 100
            print(f"✅ Reduziu {diff:.1f}%")
        
        return True
        
    except Exception as e:
        print(f"❌ Erro ao salvar: {e}")
        return False


def main():
    """Função principal"""
    print()
    
    # Arquivos
    input_gif = "assets/bolt/abertura_mascote.gif"
    output_gif = "assets/bolt/abertura_mascote_sem_fundo.gif"
    
    # Verificar se arquivo existe
    if not os.path.exists(input_gif):
        print(f"❌ Arquivo não encontrado: {input_gif}")
        print()
        print(f"📁 Arquivos .gif encontrados:")
        for root, dirs, files in os.walk("assets/bolt"):
            for file in files:
                if file.endswith('.gif'):
                    print(f"   - {os.path.join(root, file)}")
        return
    
    # Processar
    success = remove_gif_background(input_gif, output_gif)
    
    print()
    print(f"=" * 60)
    
    if success:
        print(f"✅ CONCLUÍDO COM SUCESSO!")
        print(f"=" * 60)
        print()
        print(f"📋 Próximos passos:")
        print()
        print(f"1. Verificar o resultado:")
        print(f"   Abra: {output_gif}")
        print()
        print(f"2. Se estiver bom, substituir o original:")
        print(f"   Move-Item {output_gif} {input_gif} -Force")
        print()
        print(f"3. Rebuild e deploy:")
        print(f"   flutter clean")
        print(f"   flutter build web --release")
        print(f"   firebase deploy --only hosting")
    else:
        print(f"❌ ERRO NO PROCESSAMENTO")
        print(f"=" * 60)
        print()
        print(f"Verifique:")
        print(f"1. Se rembg está instalado: pip install rembg[cpu]")
        print(f"2. Se Pillow está instalado: pip install pillow")
        print(f"3. Se o arquivo existe: {input_gif}")
    
    print()


if __name__ == "__main__":
    main()
