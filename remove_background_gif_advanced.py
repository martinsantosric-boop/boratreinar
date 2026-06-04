#!/usr/bin/env python3
"""
Script AVANÇADO para remover fundo de GIFs animados
Com otimização, redimensionamento e opções de qualidade
"""

from PIL import Image
from rembg import remove
import os
import sys

def optimize_gif(frames, durations, max_colors=256):
    """Otimiza GIF reduzindo paleta de cores"""
    optimized = []
    for frame in frames:
        # Converter para P (palette) com quantização
        if frame.mode == 'RGBA':
            # Criar paleta adaptativa
            frame_p = frame.quantize(colors=max_colors, method=2)
            optimized.append(frame_p)
        else:
            optimized.append(frame)
    return optimized

def resize_gif_frames(frames, max_width=800, max_height=800):
    """Redimensiona frames mantendo proporção"""
    resized = []
    for frame in frames:
        # Calcular novo tamanho mantendo aspect ratio
        width, height = frame.size
        
        if width > max_width or height > max_height:
            ratio = min(max_width / width, max_height / height)
            new_width = int(width * ratio)
            new_height = int(height * ratio)
            
            frame_resized = frame.resize(
                (new_width, new_height),
                Image.Resampling.LANCZOS
            )
            resized.append(frame_resized)
        else:
            resized.append(frame)
    
    return resized

def remove_gif_background(input_path, output_path, options=None):
    """
    Remove o fundo de um GIF animado frame por frame
    
    Args:
        input_path: Caminho do GIF original
        output_path: Caminho para salvar GIF sem fundo
        options: Dict com opções (resize, optimize, quality)
    """
    options = options or {}
    
    print(f"=" * 70)
    print(f"🎬 REMOVEDOR DE FUNDO DE GIF - AVANÇADO")
    print(f"=" * 70)
    print(f"📂 Entrada: {input_path}")
    print(f"💾 Saída: {output_path}")
    print()
    
    if options.get('resize'):
        print(f"📐 Redimensionar: {options['resize_width']}x{options['resize_height']} (máx)")
    if options.get('optimize'):
        print(f"🎨 Otimizar: {options.get('max_colors', 256)} cores")
    if options.get('quality'):
        print(f"✨ Qualidade: {options['quality']}")
    print()
    
    # Abrir o GIF
    try:
        gif = Image.open(input_path)
    except Exception as e:
        print(f"❌ Erro ao abrir arquivo: {e}")
        return False
    
    # Obter informações
    try:
        n_frames = gif.n_frames
        print(f"📊 Frames: {n_frames}")
        print(f"📐 Tamanho: {gif.size[0]}x{gif.size[1]} pixels")
        print()
    except AttributeError:
        n_frames = 1
    
    # Processar cada frame
    frames = []
    durations = []
    
    for frame_num in range(n_frames):
        gif.seek(frame_num)
        frame = gif.convert('RGBA')
        
        progress = f"[{frame_num + 1}/{n_frames}]"
        print(f"🔄 {progress} Processando...", end=' ')
        
        # Remover fundo
        try:
            frame_no_bg = remove(frame)
            frames.append(frame_no_bg)
            
            # Duração
            duration = gif.info.get('duration', 100)
            durations.append(duration)
            
            print("✅")
            
        except Exception as e:
            print(f"❌ Erro: {e}")
            return False
    
    print()
    
    # Aplicar otimizações
    if options.get('resize'):
        print(f"📐 Redimensionando frames...")
        frames = resize_gif_frames(
            frames,
            options.get('resize_width', 800),
            options.get('resize_height', 800)
        )
        print(f"✅ Novo tamanho: {frames[0].size[0]}x{frames[0].size[1]}")
        print()
    
    if options.get('optimize'):
        print(f"🎨 Otimizando paleta de cores...")
        # Nota: Otimização com palette pode perder transparência
        # frames = optimize_gif(frames, durations, options.get('max_colors', 256))
        print(f"⚠️  Otimização de paleta desabilitada (mantém transparência)")
        print()
    
    # Salvar novo GIF
    print(f"💾 Salvando GIF...")
    
    try:
        save_kwargs = {
            'save_all': True,
            'append_images': frames[1:] if len(frames) > 1 else [],
            'duration': durations,
            'loop': 0,
            'transparency': 0,
            'disposal': 2,
        }
        
        # Adicionar otimização se solicitado
        if options.get('optimize'):
            save_kwargs['optimize'] = True
        
        frames[0].save(output_path, **save_kwargs)
        
        print(f"✅ Salvo com sucesso!")
        print()
        
        # Estatísticas
        input_size = os.path.getsize(input_path)
        output_size = os.path.getsize(output_path)
        
        print(f"📊 ESTATÍSTICAS")
        print(f"─" * 70)
        print(f"Original:  {input_size / 1024:.2f} KB")
        print(f"Novo:      {output_size / 1024:.2f} KB")
        
        if output_size > input_size:
            diff = ((output_size - input_size) / input_size) * 100
            print(f"Diferença: +{diff:.1f}% ⚠️  (aumentou)")
        else:
            diff = ((input_size - output_size) / input_size) * 100
            print(f"Diferença: -{diff:.1f}% ✅ (reduziu)")
        
        return True
        
    except Exception as e:
        print(f"❌ Erro ao salvar: {e}")
        return False


def main():
    """Função principal com menu interativo"""
    print()
    
    input_gif = "assets/bolt/abertura_mascote.gif"
    
    # Verificar arquivo
    if not os.path.exists(input_gif):
        print(f"❌ Arquivo não encontrado: {input_gif}")
        return
    
    # Menu de opções
    print(f"=" * 70)
    print(f"🎬 CONFIGURAÇÃO")
    print(f"=" * 70)
    print()
    print(f"Opções:")
    print(f"1. Apenas remover fundo (padrão)")
    print(f"2. Remover fundo + redimensionar (800x800 máx)")
    print(f"3. Remover fundo + redimensionar + otimizar")
    print()
    
    try:
        choice = input("Escolha (1-3) [1]: ").strip() or "1"
    except:
        choice = "1"
    
    options = {}
    
    if choice == "2" or choice == "3":
        options['resize'] = True
        options['resize_width'] = 800
        options['resize_height'] = 800
    
    if choice == "3":
        options['optimize'] = True
        options['max_colors'] = 256
    
    print()
    
    # Processar
    output_gif = "assets/bolt/abertura_mascote_sem_fundo.gif"
    success = remove_gif_background(input_gif, output_gif, options)
    
    print()
    print(f"=" * 70)
    
    if success:
        print(f"✅ CONCLUÍDO!")
        print(f"=" * 70)
        print()
        print(f"📋 Próximos passos:")
        print()
        print(f"1. Verificar resultado: {output_gif}")
        print()
        print(f"2. Se estiver bom, substituir:")
        print(f"   Move-Item {output_gif} {input_gif} -Force")
        print()
        print(f"3. Rebuild e deploy:")
        print(f"   flutter clean")
        print(f"   flutter build web --release")
        print(f"   firebase deploy --only hosting")
    else:
        print(f"❌ ERRO")
        print(f"=" * 70)
    
    print()


if __name__ == "__main__":
    main()
