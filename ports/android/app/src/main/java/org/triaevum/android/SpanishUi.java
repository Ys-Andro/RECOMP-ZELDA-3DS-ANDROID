package org.triaevum.android;

import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.LinkedHashMap;
import java.util.Map;

/** Localizes Android-host UI text to Spanish without touching the native game surface. */
public final class SpanishUi {
    private static final Map<String, String> EXACT = new LinkedHashMap<>();

    static {
        // English host labels.
        put("Settings", "Configuración"); put("Settings Profile", "Perfil de configuración");
        put("Graphics", "Gráficos"); put("Graphics Settings", "Configuración gráfica");
        put("Audio", "Audio"); put("Audio Settings", "Configuración de audio");
        put("Controls", "Controles"); put("Control Settings", "Configuración de controles");
        put("Input", "Entrada"); put("Display", "Pantalla"); put("Display Settings", "Configuración de pantalla");
        put("Advanced", "Avanzado"); put("General", "General"); put("Performance", "Rendimiento");
        put("Shaders", "Shaders"); put("Shader Cache", "Caché de shaders");
        put("Texture", "Textura"); put("Textures", "Texturas"); put("Custom Textures", "Texturas personalizadas");
        put("Resolution", "Resolución"); put("Internal Resolution", "Resolución interna");
        put("Frame Rate", "Frecuencia de cuadros"); put("FPS", "FPS"); put("VSync", "Sincronización vertical");
        put("Interpolation", "Interpolación"); put("Widescreen", "Pantalla panorámica");
        put("Aspect Ratio", "Relación de aspecto"); put("Field of View", "Campo de visión"); put("FOV", "Campo de visión");
        put("Volume", "Volumen"); put("Game Volume", "Volumen del juego"); put("Master Volume", "Volumen general");
        put("Mute", "Silenciar"); put("Language", "Idioma"); put("Touch Controls", "Controles táctiles");
        put("HUD", "HUD"); put("HUD Layout", "Distribución del HUD"); put("Edit", "Editar");
        put("Restore Defaults", "Restaurar valores predeterminados"); put("Reset", "Restablecer");
        put("Apply", "Aplicar"); put("OK", "Aceptar"); put("Cancel", "Cancelar"); put("Back", "Atrás");
        put("Close", "Cerrar"); put("Save", "Guardar"); put("Load", "Cargar");
        put("Save State", "Guardar estado"); put("Load State", "Cargar estado");
        put("Quick Save", "Guardado rápido"); put("Quick Load", "Carga rápida");
        put("Save Game", "Guardar partida"); put("Load Game", "Cargar partida"); put("Exit", "Salir");
        put("Game", "Juego"); put("ROM", "ROM"); put("Select", "Seleccionar"); put("Select ROM", "Seleccionar ROM");
        put("Import", "Importar"); put("Import ROM", "Importar ROM"); put("Launch", "Iniciar"); put("Launch Game", "Iniciar juego");
        put("Download", "Descargar"); put("Preparing", "Preparando"); put("Ready", "Listo"); put("Error", "Error");
        put("Warning", "Advertencia"); put("Retry", "Reintentar"); put("Continue", "Continuar");
        put("Yes", "Sí"); put("No", "No"); put("On", "Activado"); put("Off", "Desactivado");
        put("Enabled", "Activado"); put("Disabled", "Desactivado"); put("Enable", "Activar"); put("Disable", "Desactivar");
        put("Profiles", "Perfiles"); put("Profile", "Perfil"); put("Driver", "Controlador");
        put("Custom Driver", "Controlador personalizado"); put("Grass", "Hierba"); put("Toon", "Cel shading");
        put("Outlines", "Contornos"); put("Reflections", "Reflejos"); put("Shadows", "Sombras");
        put("Anti-Aliasing", "Antialiasing"); put("Ambient Occlusion", "Oclusión ambiental");
        put("Reset Layout", "Restablecer distribución"); put("Move", "Mover"); put("Size", "Tamaño");
        put("Opacity", "Opacidad"); put("Save Layout", "Guardar distribución"); put("Test", "Probar");
        put("About", "Acerca de"); put("Version", "Versión");

        // Portuguese labels still present in legacy settings arrays/layouts.
        put("English", "Inglés"); put("Francais", "Francés"); put("Espanol", "Español");
        put("Português", "Portugués"); put("Português (Brasil)", "Portugués (Brasil)");
        put("Desligado", "Desactivado"); put("Desligada", "Desactivada"); put("Baixa", "Baja");
        put("Média", "Media"); put("Alta", "Alta"); put("Econômico", "Económico");
        put("Equilibrado", "Equilibrado"); put("Padrão", "Predeterminado"); put("Nativo do Display", "Nativo de pantalla");
        put("Alta Definição", "Alta definición"); put("Ultra / Supersampling", "Ultra / supermuestreo");
        put("Sem Limite (Uncapped)", "Sin límite"); put("Fluido / 3x", "Fluido / 3x"); put("Ultra Fluido / 4x", "Ultra fluido / 4x");
        put("Original 3DS", "Original 3DS"); put("Nativo / 2x", "Nativo / 2x");
        put("Normal (Padrão)", "Normal (predeterminado)"); put("Restoration (MM3D)", "Restauración (MM3D)");
        put("Diretório", "Directorio"); put("Verificando texturas...", "Verificando texturas...");
        put("Configurações salvas e aplicadas!", "Configuración guardada y aplicada.");
        put("Padrões restaurados e aplicados.", "Valores predeterminados restaurados y aplicados.");
        put("Configurações", "Configuración"); put("Câmera", "Cámara"); put("Gráficos", "Gráficos");
        put("Controles", "Controles"); put("Geral", "General"); put("Jogabilidade", "Jugabilidad");
        put("Velocidade", "Velocidad"); put("Escala HUD", "Escala del HUD");
        put("Margem X (Horizontal)", "Margen X (horizontal)"); put("Margem Y (Vertical)", "Margen Y (vertical)");
        put("Opacidade dos Controles", "Opacidad de los controles"); put("Campo de Visão", "Campo de visión");
        put("Pré-carregando Texturas", "Precargando texturas"); put("Importar Save", "Importar guardado");
        put("Selecionar Arquivo", "Seleccionar archivo"); put("Excluir Driver", "Eliminar controlador");
        put("Sim", "Sí"); put("Não", "No"); put("Cancelar", "Cancelar"); put("Salvar", "Guardar");
        put("Carregar", "Cargar"); put("Selecionar", "Seleccionar"); put("Iniciar jogo", "Iniciar juego");
        put("Diretório de texturas", "Directorio de texturas"); put("Driver GPU", "Controlador GPU");
        put("Padrão do Sistema", "Predeterminado del sistema"); put("Autor", "Autor"); put("Versão", "Versión");
        put("Arquivo", "Archivo"); put("Sistema", "Sistema");
    }

    private static void put(String source, String target) { EXACT.put(source, target); }
    private SpanishUi() {}

    public static void apply(View root) {
        if (root != null) walk(root);
    }

    private static void walk(View view) {
        if (view instanceof TextView) {
            TextView text = (TextView) view;
            CharSequence value = text.getText();
            if (value != null) text.setText(translate(value.toString()));
            CharSequence description = view.getContentDescription();
            if (description != null) view.setContentDescription(translate(description.toString()));
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) walk(group.getChildAt(i));
        }
    }

    private static String translate(String input) {
        String exact = EXACT.get(input.trim());
        if (exact != null) return preserveWhitespace(input, exact);
        String result = input;
        for (Map.Entry<String, String> entry : EXACT.entrySet()) {
            result = result.replace(entry.getKey(), entry.getValue());
        }
        return result;
    }

    private static String preserveWhitespace(String original, String translated) {
        int start = 0;
        while (start < original.length() && Character.isWhitespace(original.charAt(start))) start++;
        int end = original.length();
        while (end > start && Character.isWhitespace(original.charAt(end - 1))) end--;
        return original.substring(0, start) + translated + original.substring(end);
    }
}
