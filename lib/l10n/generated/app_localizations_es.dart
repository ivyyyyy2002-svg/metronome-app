// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Luz';

  @override
  String get dark => 'Oscuro';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get defaultThemeColor => 'Por defecto';

  @override
  String get roseThemeColor => 'Rosa';

  @override
  String get purpleThemeColor => 'Púrpura';

  @override
  String get warmThemeColor => 'Amarillo';

  @override
  String get tealThemeColor => 'verde azulado';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get chinese => '中文';

  @override
  String get french => 'francés';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get spanish => 'Español';

  @override
  String get homeTitle => 'Hogar';

  @override
  String get appName => 'metrinote';

  @override
  String get practiceTab => 'Práctica';

  @override
  String get sequencesTab => 'Secuencias';

  @override
  String get toolsTab => 'Herramientas';

  @override
  String get basicsTab => 'Lo esencial';

  @override
  String get readyTitle => 'Hola, \n¿Listo para practicar?';

  @override
  String get readyDescription =>
      'Toque el botón a continuación para iniciar una nueva sesión de metrónomo con la última configuración utilizada.';

  @override
  String get startMetronome => 'Iniciar metrónomo';

  @override
  String get musicBasics => 'Conceptos básicos de música';

  @override
  String get practiceHistory => 'Historia de la práctica';

  @override
  String get todayPractice => 'Hoy';

  @override
  String get last7Days => 'últimos 7 días';

  @override
  String get lastSession => 'Última sesión';

  @override
  String get mostUsedBpm => 'BPM más utilizados';

  @override
  String get favoriteInstrument => 'Instrumento favorito';

  @override
  String get noPracticeYet => 'Aún no se ha registrado ninguna práctica.';

  @override
  String get basicsIntro =>
      'Referencias rápidas sobre ritmo, métrica y notación.';

  @override
  String get bpmBasicsTitle => 'BPM';

  @override
  String get bpmBasicsBody =>
      'BPM significa latidos por minuto. Utilice un BPM más lento cuando aprenda un nuevo patrón, luego increméntelo gradualmente cuando su ritmo se sienta estable.';

  @override
  String get timeSignatureBasicsTitle => 'Firma de tiempo';

  @override
  String get timeSignatureBasicsBody =>
      'El número superior indica cuántos tiempos hay en cada compás. 4/4 es común para pop y ejercicios de práctica, mientras que 3/4 a menudo se siente como un vals.';

  @override
  String get subdivisionBasicsTitle => 'Subdivisión';

  @override
  String get subdivisionBasicsBody =>
      'La subdivisión controla cómo se divide el ritmo. Quarter es simple y estable; El octavo y el decimosexto hacen que el clic parezca más detallado.';

  @override
  String get downbeatBasicsTitle => 'pesimista';

  @override
  String get downbeatBasicsBody =>
      'El tiempo fuerte es el primer tiempo de un compás. Un primer clic más fuerte le ayuda a escuchar la forma del compás en lugar de contar cada tiempo por igual.';

  @override
  String get jianpuBasicsTitle => 'Jianpu';

  @override
  String get jianpuBasicsBody =>
      'Jianpu usa números para los grados de escala, como 1 2 3 5 6. Es común en el aprendizaje de instrumentos chinos y se puede asignar a nombres de notas eligiendo una clave.';

  @override
  String get westernNotationBasicsTitle => 'Notas occidentales';

  @override
  String get westernNotationBasicsBody =>
      'Los nombres de notas occidentales usan A-G. Los sostenidos (#) suben una nota un semitono y los bemoles (b) bajan una nota un semitono.';

  @override
  String get easternNotationBasicsTitle => 'notas orientales';

  @override
  String get easternNotationBasicsBody =>
      'La notación oriental usa Sa Re Ga Ma Pa Dha Ni, o S R G M P D N. En esta aplicación se asignan a C D E F G A B.';

  @override
  String get octaveNotationBasicsTitle => 'Octavas';

  @override
  String get octaveNotationBasicsBody =>
      'Utilice \' para una octava superior y coma para una octava inferior. Por ejemplo, C\' es mayor que C, y C, es menor que C.';

  @override
  String get groupedNotesBasicsTitle => 'Notas agrupadas';

  @override
  String get groupedNotesBasicsBody =>
      'Un espacio pasa al siguiente tiempo. Las notas sin espacio se tocan dentro del mismo tiempo, por lo que C D E FG junta F y G en el cuarto tiempo.';

  @override
  String get heldNotesBasicsTitle => 'Notas retenidas';

  @override
  String get heldNotesBasicsBody =>
      'Un guión (-) mantiene la nota anterior durante otro tiempo. Por ejemplo, C - D E mantiene C sonando durante el segundo tiempo.';

  @override
  String get scalePatternGenerator => 'Generador de patrones de escala';

  @override
  String get scalePatternDescription =>
      'Crea un patrón de escala limpio y envíalo a tu secuencia de notas.';

  @override
  String get notation => 'Notación';

  @override
  String get westernNotation => 'Occidental';

  @override
  String get easternNotation => 'Oriental';

  @override
  String get rootKey => 'clave raíz';

  @override
  String get scale => 'Escala';

  @override
  String get direction => 'Dirección';

  @override
  String get ascending => 'Ascendente';

  @override
  String get descending => 'Descendente';

  @override
  String get upAndDown => 'arriba y abajo';

  @override
  String get majorPentatonic => 'Pentatónica mayor';

  @override
  String get minorPentatonic => 'pentatónico menor';

  @override
  String get majorScale => 'escala mayor';

  @override
  String get minorScale => 'escala menor';

  @override
  String get generatedPattern => 'Patrón generado';

  @override
  String get useAsSequence => 'Usar como secuencia';

  @override
  String get patternAppliedNotice => 'Patrón agregado al editor de secuencia.';

  @override
  String get jianpuConverter => 'Convertidor Jianpu';

  @override
  String get jianpuConverterDescription =>
      'Convierta la notación numerada en nombres de notas reproducibles eligiendo una clave.';

  @override
  String get jianpuInput => 'entrada de jianpu';

  @override
  String get convertedSequence => 'Secuencia convertida';

  @override
  String get practiceNotePattern => 'Patrón de notas de práctica';

  @override
  String get notePatternDescription =>
      'Elija el orden de las notas que tocará el metrónomo.';

  @override
  String get notesToPlay => 'notas para tocar';

  @override
  String get noteInputHelper =>
      'Utilice A-G o S R G M P D N. Utilice \', coma, / y - para octavas, notas agrupadas y retenciones.';

  @override
  String get applySequence => 'Aplicar secuencia';

  @override
  String get deleteNote => 'Borrar';

  @override
  String get clearNotes => 'Claro';

  @override
  String get sequenceSavedNotice => 'Patrón de notas guardado.';

  @override
  String get sequenceExample => 'Ejemplos: ABCDEFG, C#D#EF#G#, etc.';

  @override
  String get sequenceError =>
      'Ingrese al menos una nota occidental u oriental válida.';

  @override
  String get metronomeTitle => 'Metrónomo';

  @override
  String get advanced => 'Avanzado';

  @override
  String get advancedSettings => 'Configuración avanzada';

  @override
  String get bpm => 'BPM';

  @override
  String get start => 'Comenzar';

  @override
  String get stop => 'Detener';

  @override
  String get reset => 'Reiniciar';

  @override
  String get click => 'Hacer clic';

  @override
  String get clickSound => 'sonido de clic';

  @override
  String get volumeBalance => 'equilibrio de volumen';

  @override
  String get clickVolume => 'Haga clic en volumen';

  @override
  String get instrumentVolume => 'Volumen del instrumento';

  @override
  String get sound => 'Sonido';

  @override
  String get preview => 'Avance';

  @override
  String get instrument => 'Instrumento';

  @override
  String get tutorialNext => 'Próximo';

  @override
  String get tutorialSkip => 'Saltar todo';

  @override
  String get tutorialDone => 'Hecho';

  @override
  String get tutorialReplay => 'Ver tutorial nuevamente';

  @override
  String get tutorialTryIt => 'Pruébalo:';

  @override
  String get tutorialWellDone => '¡Lindo!';

  @override
  String get tutorialTempoTitle => 'Tempo, tiempos y el péndulo';

  @override
  String get tutorialTempoBody =>
      'El péndulo oscila una vez por tiempo, y el número grande es el tempo en BPM (tiempos por minuto): cuántos tiempos caben en un minuto. La fila de puntos muestra dónde se encuentra dentro del compás: el primer punto más brillante es el tiempo fuerte acentuado.';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 latido por segundo\n120 BPM = 2 latidos por segundo (el doble de rápido)';

  @override
  String get tutorialBpmDragTitle => 'Establece tu propio ritmo';

  @override
  String get tutorialBpmDragBody =>
      'La práctica lenta es el secreto para tocar limpiamente: elige un tempo en el que puedas tocar cada nota correctamente y sólo sube el ritmo cuando te resulte fácil. El control deslizante va de 30 (muy lento) a 240 (muy rápido).';

  @override
  String get tutorialBpmDragAction =>
      'arrastre el control deslizante de tempo a cualquier valor.';

  @override
  String get tutorialSequenceTitle => 'Tu patrón de notas';

  @override
  String get tutorialSequenceBody =>
      'Este metrónomo hace más que hacer clic: puede reproducir una melodía, una nota por tiempo, haciendo un bucle con su patrón mientras toca. Este panel muestra el patrón cargado en este momento. Tócalo en cualquier momento para editar las notas sin salir de esta página.';

  @override
  String get tutorialToggleTitle => 'Clic, notas o ambos';

  @override
  String get tutorialToggleBody =>
      '\"Clic\" es el clásico tic que marca el tiempo. \"Sonido\" reproduce su patrón de notas en el instrumento seleccionado. Mantén ambos encendidos para escuchar la melodía sobre el ritmo o apaga uno para concentrarte.';

  @override
  String get tutorialToggleAction =>
      'Apague uno de los interruptores y vuelva a encenderlo.';

  @override
  String get tutorialMeterTitle => 'Metro y subdivisión';

  @override
  String get tutorialMeterBody =>
      'El compás agrupa los tiempos en compases: en 4/4 cuentas 1-2-3-4 y comienzas de nuevo, y el tiempo 1 obtiene el acento. La unidad de tiempo subdivide cada tiempo en clics más pequeños, lo que ayuda cuando las notas se mueven más rápido que el tiempo.';

  @override
  String get tutorialMeterExample =>
      '4/4 = 4 tiempos por compás (el más común)\n3/4 = cuenta en 3, como un vals\nUnidad de octavo tiempo = 2 clics por tiempo';

  @override
  String get tutorialTransportTitle => 'Escúchalo en vivo';

  @override
  String get tutorialTransportBody =>
      'Todo está configurado: presiona Inicio y escucha: el primer tiempo acentuado, luego las notas que llegan a cada tiempo. Detener pausa la sesión; Restablecer salta al principio de su patrón.';

  @override
  String get tutorialTransportAction =>
      'presione Inicio y escuche uno o dos compases.';

  @override
  String get tutorialAdvancedTitle => 'Configuraciones avanzadas';

  @override
  String get tutorialAdvancedBody =>
      'Cuando los valores predeterminados parezcan limitantes, abra este panel para cambiar el sonido del clic, elija el instrumento que toca sus notas, ajuste los acentos o cambie la octava base hacia arriba y hacia abajo.';

  @override
  String get tutorialHomePracticeTitle =>
      '¡Bienvenido! La práctica comienza aquí.';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote es un metrónomo que también puede tocar las notas que quieras practicar, para que escuches el ritmo y la melodía juntos. Este botón abre la página de práctica con su patrón de notas actual ya cargado.';

  @override
  String get tutorialHomeHistoryTitle => 'Tu historial de práctica';

  @override
  String get tutorialHomeHistoryBody =>
      'Aquí se realiza un seguimiento de cada sesión: minutos practicados durante los últimos 7 días, su tempo más utilizado y su instrumento favorito. Establece una meta diaria y el anillo de progreso te mantendrá honesto.';

  @override
  String get tutorialHomeTabsTitle => 'Cuatro pestañas, un flujo de trabajo';

  @override
  String get tutorialHomeTabsBody =>
      'La práctica es la base de operaciones. Secuencias es donde construyes y guardas patrones de notas. Herramientas genera patrones para usted. Conceptos básicos explica los términos musicales que utiliza esta aplicación. Visitémoslos en orden.';

  @override
  String get tutorialHomeExamplesTitle => 'Partir de un ejemplo';

  @override
  String get tutorialHomeExamplesBody =>
      '¿No estás seguro de qué practicar? Estos patrones ya preparados se cargan con un solo toque: una escala mayor occidental o un ciclo raga oriental. Cargue uno y modifíquelo para hacerlo suyo.';

  @override
  String get tutorialHomeSequencesTitle => 'Escribe tu propio patrón';

  @override
  String get tutorialHomeSequencesBody =>
      'Escriba los nombres de las notas separados por espacios o toque las fichas de notas debajo del campo. Tanto las letras occidentales (A B C…) como el sargamo oriental (S R G M…) funcionan. Dale un nombre al patrón y guárdalo para reutilizarlo en cualquier momento.';

  @override
  String get tutorialHomeSequencesExample =>
      'C D E F → cuatro notas, una por tiempo\nG - → \'-\' mantiene G durante un tiempo adicional\nE/F → \'/\' encaja dos notas en un tiempo\nC\' octava alta · C, octava baja';

  @override
  String get tutorialHomeToolsTitle => 'Deje que las herramientas escriban';

  @override
  String get tutorialHomeToolsBody =>
      'Tools tiene dos generadores que escriben patrones por usted: un generador de escalas y un conversor de jianpu (notación numerada). Echemos un vistazo rápido a ambos.';

  @override
  String get tutorialHomeScaleGenTitle => 'Generador de patrones de escala';

  @override
  String get tutorialHomeScaleGenBody =>
      'Elija una clave fundamental, un tipo de escala, un rango de octava y una dirección: escribirá el patrón completo por usted. \"Usar patrón\" coloca el resultado directamente en su editor de secuencia.';

  @override
  String get tutorialHomeJianpuTitle => 'Convertidor Jianpu';

  @override
  String get tutorialHomeJianpuBody =>
      'Si lees la notación numerada (1 2 3 = do re mi), pégala aquí y se convertirá en un patrón reproducible. También se entienden los puntos y guiones de octava para las notas retenidas.';

  @override
  String get tutorialHomeBasicsTitle => 'Aprende las palabras';

  @override
  String get tutorialHomeBasicsBody =>
      'Una parada más: Conceptos básicos es un glosario en lenguaje sencillo de cada término que utiliza esta aplicación. Leamos juntos los cuatro más importantes.';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM significa latidos por minuto: 60 BPM es exactamente un latido por segundo. Este es el número que estableces con el control deslizante de tempo en la página de práctica. Regla de oro: empezar más lento de lo que te resulte cómodo.';

  @override
  String get tutorialBasicsMeterBody =>
      'El número superior indica cuántos tiempos contiene cada compás y el tiempo 1 siempre recibe el acento. Puedes elegir esto en el chip medidor de la página de práctica: 4/4 es el valor predeterminado seguro para la mayoría de la música.';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'La subdivisión divide cada tiempo en clics iguales más pequeños: los octavos dan 2 clics por tiempo, los dieciseisavos dan 4. Actívelo cuando sus notas se muevan más rápido que el tiempo principal.';

  @override
  String get tutorialBasicsNotationBody =>
      'Esta aplicación acepta dos sistemas de nombres para las mismas notas: letras occidentales (C D E F G A B) y sargamo oriental (S R G M P D N). Las tarjetas cercanas explican las marcas de octava, las notas mantenidas y la agrupación.';

  @override
  String get tutorialHomeReturnTitle => 'De vuelta a la base de operaciones';

  @override
  String get tutorialHomeReturnBody =>
      'Ese es el recorrido por las pestañas. Selecciona Practica tú mismo para saber siempre cómo volver al punto de partida.';

  @override
  String get tutorialStartSessionTitle => 'Comience cuando esté listo';

  @override
  String get tutorialStartSessionBody =>
      'Ahora presione Iniciar metrónomo usted mismo. Eso abre el espacio de trabajo de práctica, donde continuará el tutorial práctico del metrónomo.';

  @override
  String get tutorialHomeSettingsTitle => 'Configuración y reproducción';

  @override
  String get tutorialHomeSettingsBody =>
      'El tema, los colores y el lenguaje viven detrás de este equipo. Si alguna vez olvidas cómo funciona algo, abre Configuración y toca \"Ver tutorial nuevamente\". Presione Listo y luego volveremos a practicar juntos.';

  @override
  String get tutorialScoreTitle => 'Práctica de partitura en iPad';

  @override
  String get tutorialScoreBody =>
      'En pantallas más grandes en formato horizontal, cargue aquí una imagen de partitura o un PDF y practique mientras el metrónomo permanece visible al lado. Puede hacer zoom, pasar páginas e ir a pantalla completa.';

  @override
  String get notesLoaded => 'notas cargadas';

  @override
  String get noSequenceLoaded => 'Ninguna secuencia cargada';

  @override
  String get editNoteSequence => 'Editar secuencia de notas';

  @override
  String get savedSequences => 'Secuencias guardadas';

  @override
  String get sequenceName => 'Nombre de secuencia';

  @override
  String get searchSequences => 'Secuencias de búsqueda';

  @override
  String get saveSequence => 'Ahorrar';

  @override
  String get loadSequence => 'Carga';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get quickEdit => 'Edición rápida';

  @override
  String get importSequence => 'Secuencia de importación';

  @override
  String get noSavedSequences => 'No hay secuencias guardadas';

  @override
  String get sequenceNameError => 'Ingrese un nombre antes de guardar.';

  @override
  String get alreadySavedNotice => 'Ya guardado.';

  @override
  String get replace => 'Reemplazar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get apply => 'Aplicar';

  @override
  String get close => 'Cerca';

  @override
  String get done => 'Hecho';

  @override
  String get timeSignature => 'Firma de tiempo';

  @override
  String get beatUnit => 'Subdivisión';

  @override
  String get subdivisionHalf => 'Medio';

  @override
  String get subdivisionQuarter => 'Cuarto';

  @override
  String get subdivisionEighth => 'Octavo';

  @override
  String get subdivisionSixteenth => 'Decimosexto';

  @override
  String get subdivisionDottedHalf => 'Mitad punteada';

  @override
  String get subdivisionDottedQuarter => 'Cuarto punteado';

  @override
  String get subdivisionDottedEighth => 'Octavo punteado';

  @override
  String get missingInstrument => 'desaparecido';

  @override
  String get scorePreview => 'Puntaje';

  @override
  String get addScore => 'Añadir puntuación';

  @override
  String get importScoreFromFiles => 'Elija entre archivos';

  @override
  String get importScoreFromPhotos => 'Elige entre fotos';

  @override
  String get deleteScore => 'Eliminar puntuación';

  @override
  String get chooseScore => 'Elige puntuación';

  @override
  String get scorePlaceholderTitle => 'No se agregó puntuación';

  @override
  String get scorePlaceholderBody =>
      'Este espacio está reservado para un PDF o una imagen de partitura.';

  @override
  String tutorialStepCount(int current, int total) {
    return '$current de $total';
  }

  @override
  String tutorialTapTabAction(String tabName) {
    return 'toque \"$tabName\" en la barra de abajo.';
  }

  @override
  String noteSequenceTooLong(int maxNotes) {
    return 'Utilice $maxNotes notas o menos para una secuencia.';
  }

  @override
  String replaceSequenceQuestion(String name) {
    return 'Ya existe una secuencia denominada \"$name\". ¿Reemplazarlo?';
  }

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) {
    return 'Mostrando $visibleCount de $totalCount';
  }

  @override
  String get quickEntry => 'Entrada rápida';

  @override
  String get notes => 'Notas';

  @override
  String get modifiers => 'Modificadores';

  @override
  String get zoomOut => 'alejar';

  @override
  String get zoomIn => 'Dar un golpe de zoom';

  @override
  String get previousPage => 'Pagina anterior';

  @override
  String get nextPage => 'Página siguiente';

  @override
  String get fullscreen => 'Pantalla completa';

  @override
  String get show => 'Espectáculo';

  @override
  String get hide => 'Esconder';

  @override
  String get exampleSequences => 'Secuencias de ejemplo';

  @override
  String noPlayableAssets(String instrument) {
    return 'No se encontraron recursos reproducibles para $instrument';
  }
}
