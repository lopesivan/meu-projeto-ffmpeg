#include <iostream>
#include <string>

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libswscale/swscale.h>
}

void print_ffmpeg_info() {
    std::cout << "═══════════════════════════════════════════\n";
    std::cout << "    FFmpeg Demo Application\n";
    std::cout << "═══════════════════════════════════════════\n\n";
    
    // Versão do FFmpeg
    std::cout << "📦 FFmpeg Version: " << av_version_info() << "\n";
    std::cout << "   libavcodec:  " << LIBAVCODEC_VERSION_MAJOR << "." 
              << LIBAVCODEC_VERSION_MINOR << "." 
              << LIBAVCODEC_VERSION_MICRO << "\n";
    std::cout << "   libavformat: " << LIBAVFORMAT_VERSION_MAJOR << "." 
              << LIBAVFORMAT_VERSION_MINOR << "." 
              << LIBAVFORMAT_VERSION_MICRO << "\n";
    std::cout << "   libavutil:   " << LIBAVUTIL_VERSION_MAJOR << "." 
              << LIBAVUTIL_VERSION_MINOR << "." 
              << LIBAVUTIL_VERSION_MICRO << "\n";
    std::cout << "   libswscale:  " << LIBSWSCALE_VERSION_MAJOR << "." 
              << LIBSWSCALE_VERSION_MINOR << "." 
              << LIBSWSCALE_VERSION_MICRO << "\n\n";
}

void list_codecs() {
    std::cout << "🎬 Codecs de Vídeo suportados:\n";
    std::cout << "───────────────────────────────────────────\n";
    
    void* opaque = nullptr;
    const AVCodec* codec = nullptr;
    int count = 0;
    
    while ((codec = av_codec_iterate(&opaque)) != nullptr) {
        if (codec->type == AVMEDIA_TYPE_VIDEO && av_codec_is_decoder(codec)) {
            std::cout << "  • " << codec->name;
            if (codec->long_name) {
                std::cout << " - " << codec->long_name;
            }
            std::cout << "\n";
            
            count++;
            if (count >= 10) {  // Limitar a 10 para não poluir
                std::cout << "  ... (" << "mais codecs disponíveis" << ")\n";
                break;
            }
        }
    }
    std::cout << "\n";
}

void list_formats() {
    std::cout << "📁 Formatos de Container suportados:\n";
    std::cout << "───────────────────────────────────────────\n";
    
    void* opaque = nullptr;
    const AVInputFormat* fmt = nullptr;
    int count = 0;
    
    while ((fmt = av_demuxer_iterate(&opaque)) != nullptr) {
        std::cout << "  • " << fmt->name;
        if (fmt->long_name) {
            std::cout << " - " << fmt->long_name;
        }
        std::cout << "\n";
        
        count++;
        if (count >= 10) {  // Limitar a 10
            std::cout << "  ... (" << "mais formatos disponíveis" << ")\n";
            break;
        }
    }
    std::cout << "\n";
}

bool probe_file(const char* filename) {
    std::cout << "🔍 Analisando arquivo: " << filename << "\n";
    std::cout << "───────────────────────────────────────────\n";
    
    AVFormatContext* fmt_ctx = nullptr;
    
    // Abre o arquivo
    int ret = avformat_open_input(&fmt_ctx, filename, nullptr, nullptr);
    if (ret < 0) {
        char errbuf[128];
        av_strerror(ret, errbuf, sizeof(errbuf));
        std::cerr << "❌ Erro ao abrir arquivo: " << errbuf << "\n";
        return false;
    }
    
    // Lê informações dos streams
    ret = avformat_find_stream_info(fmt_ctx, nullptr);
    if (ret < 0) {
        std::cerr << "❌ Erro ao ler informações dos streams\n";
        avformat_close_input(&fmt_ctx);
        return false;
    }
    
    // Mostra informações
    std::cout << "✓ Formato: " << fmt_ctx->iformat->long_name << "\n";
    std::cout << "✓ Duração: " << (fmt_ctx->duration / AV_TIME_BASE) << " segundos\n";
    std::cout << "✓ Bitrate: " << (fmt_ctx->bit_rate / 1000) << " kbps\n";
    std::cout << "✓ Número de streams: " << fmt_ctx->nb_streams << "\n\n";
    
    // Lista cada stream
    for (unsigned int i = 0; i < fmt_ctx->nb_streams; i++) {
        AVStream* stream = fmt_ctx->streams[i];
        AVCodecParameters* codecpar = stream->codecpar;
        
        std::cout << "  Stream #" << i << ":\n";
        std::cout << "    Tipo: ";
        
        switch (codecpar->codec_type) {
            case AVMEDIA_TYPE_VIDEO:
                std::cout << "Vídeo\n";
                std::cout << "    Codec: " << avcodec_get_name(codecpar->codec_id) << "\n";
                std::cout << "    Resolução: " << codecpar->width << "x" << codecpar->height << "\n";
                std::cout << "    FPS: " << av_q2d(stream->avg_frame_rate) << "\n";
                break;
            case AVMEDIA_TYPE_AUDIO:
                std::cout << "Áudio\n";
                std::cout << "    Codec: " << avcodec_get_name(codecpar->codec_id) << "\n";
                std::cout << "    Sample Rate: " << codecpar->sample_rate << " Hz\n";
                std::cout << "    Canais: " << codecpar->ch_layout.nb_channels << "\n";
                break;
            case AVMEDIA_TYPE_SUBTITLE:
                std::cout << "Legenda\n";
                break;
            default:
                std::cout << "Outro\n";
                break;
        }
        std::cout << "\n";
    }
    
    avformat_close_input(&fmt_ctx);
    return true;
}

int main(int argc, char* argv[]) {
    print_ffmpeg_info();
    list_codecs();
    list_formats();
    
    // Se passou arquivo como argumento, analisa
    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            probe_file(argv[i]);
        }
    } else {
        std::cout << "💡 Uso:\n";
        std::cout << "   " << argv[0] << " <arquivo_video>\n\n";
        std::cout << "   Exemplo:\n";
        std::cout << "   " << argv[0] << " video.mp4\n";
        std::cout << "   " << argv[0] << " audio.mp3 video.mkv\n\n";
    }
    
    return 0;
}
