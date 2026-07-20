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
  String get click => 'Clic';

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
  String get tutorialNext => 'Siguiente';

  @override
  String get tutorialSkip => 'Omitir todo';

  @override
  String get tutorialDone => 'Hecho';

  @override
  String get tutorialReplay => 'Repetir tutorial';

  @override
  String get tutorialTryIt => 'Pruébalo:';

  @override
  String get tutorialWellDone => '¡Bien!';

  @override
  String get tutorialTempoTitle => 'Tempo, pulsos y péndulo';

  @override
  String get tutorialTempoBody =>
      'El péndulo oscila una vez por pulso. El número grande es el tempo en BPM, es decir, pulsos por minuto. La fila de puntos muestra en qué parte del compás estás, y el punto más brillante es el tiempo fuerte.';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 pulso por segundo\n120 BPM = 2 pulsos por segundo (el doble de rápido)';

  @override
  String get tutorialBpmDragTitle => 'Ajusta el tempo';

  @override
  String get tutorialBpmDragBody =>
      'Elige un tempo en el que puedas tocar cada nota correctamente y súbelo cuando te resulte fácil. El deslizador va de 30 a 240.';

  @override
  String get tutorialBpmDragAction =>
      'arrastra el deslizador de tempo a cualquier valor.';

  @override
  String get tutorialSequenceTitle => 'Tu patrón de notas';

  @override
  String get tutorialSequenceBody =>
      'Este metrónomo hace más que marcar el pulso. Toca tu patrón de notas como una melodía, una nota por pulso, en bucle mientras tocas. Este panel muestra el patrón cargado ahora. Tócalo para editar las notas.';

  @override
  String get tutorialToggleTitle => 'Clic y Sonido';

  @override
  String get tutorialToggleBody =>
      '«Clic» es el tic clásico que marca el tiempo. «Sonido» toca tu patrón de notas con el instrumento elegido. Deja los dos activados para oír la melodía sobre el pulso, o apaga uno para concentrarte en el otro.';

  @override
  String get tutorialToggleAction =>
      'apaga uno de los interruptores y vuelve a encenderlo.';

  @override
  String get tutorialMeterTitle => 'Compás y subdivisión';

  @override
  String get tutorialMeterBody =>
      'El compás agrupa los pulsos. En 4/4 cuentas 1-2-3-4 y vuelves a empezar, y el pulso 1 lleva el acento. La subdivisión parte cada pulso en clics más pequeños, útil cuando tus notas van más rápido que el pulso.';

  @override
  String get tutorialMeterExample =>
      '4/4 = 4 pulsos por compás, el más común\n3/4 = cuenta de 3, como un vals\nSubdivisión en corcheas = 2 clics por pulso';

  @override
  String get tutorialTransportTitle => 'Escúchalo';

  @override
  String get tutorialTransportBody =>
      'Todo listo. Pulsa Comenzar y escucha: el primer pulso acentuado y luego tus notas cayendo en cada pulso. Detener pausa la sesión y Reiniciar vuelve al principio del patrón.';

  @override
  String get tutorialTransportAction =>
      'pulsa Comenzar y escucha uno o dos compases.';

  @override
  String get tutorialAdvancedTitle => 'Ajustes avanzados';

  @override
  String get tutorialAdvancedBody =>
      'Cuando los valores por defecto se queden cortos, abre este panel para cambiar el sonido del clic, elegir el instrumento que toca tus notas, ajustar los acentos o mover la octava base.';

  @override
  String get tutorialHomePracticeTitle =>
      'Bienvenido. La práctica empieza aquí';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote es un metrónomo que además toca las notas que quieres practicar, así oyes el pulso y la melodía a la vez. Este botón abre la página de práctica con tu patrón de notas ya cargado.';

  @override
  String get tutorialHomeHistoryTitle => 'Historial de práctica';

  @override
  String get tutorialHomeHistoryBody =>
      'Cada sesión queda registrada aquí: minutos practicados en los últimos 7 días, tu tempo más usado y tu instrumento más usado. Fija un objetivo diario y el anillo de progreso te mostrará cuánto llevas.';

  @override
  String get tutorialHomeTabsTitle => 'Cuatro pestañas';

  @override
  String get tutorialHomeTabsBody =>
      '«Práctica» es la página principal. «Secuencias» es donde creas y guardas patrones de notas. «Herramientas» los genera por ti. «Lo esencial» explica los términos musicales de la aplicación. Vamos a verlas en orden.';

  @override
  String get tutorialHomeExamplesTitle => 'Empieza con un ejemplo';

  @override
  String get tutorialHomeExamplesBody =>
      '¿No sabes qué practicar? Estos patrones listos se cargan con un toque, incluida una escala mayor occidental y un ciclo de raga oriental. Carga uno y adáptalo a tu gusto.';

  @override
  String get tutorialHomeSequencesTitle => 'Escribe tu propio patrón';

  @override
  String get tutorialHomeSequencesBody =>
      'Escribe los nombres de las notas separados por espacios o toca los botones de nota debajo del campo. Funcionan tanto las letras occidentales (A B C…) como el sargam oriental (S R G M…). Ponle nombre al patrón y guárdalo para cargarlo después.';

  @override
  String get tutorialHomeSequencesExample =>
      'C D E F → cuatro notas, una por pulso\nG - → «-» mantiene G un pulso más\nE/F → «/» mete dos notas en un pulso\nC\' octava alta · C, octava baja';

  @override
  String get tutorialHomeToolsTitle => 'Deja que Herramientas genere patrones';

  @override
  String get tutorialHomeToolsBody =>
      'La pestaña «Herramientas» tiene dos generadores: uno de escalas y un conversor de jianpu. Ambos escriben patrones por ti. Veamos cada uno.';

  @override
  String get tutorialHomeScaleGenTitle => 'Generador de patrones de escala';

  @override
  String get tutorialHomeScaleGenBody =>
      'Elige tónica, tipo de escala, rango de octavas y dirección, y escribirá el patrón completo. «Usar como secuencia» lo lleva directamente a tu editor de secuencias.';

  @override
  String get tutorialHomeJianpuTitle => 'Conversor de jianpu';

  @override
  String get tutorialHomeJianpuBody =>
      'Si lees notación numérica (1 2 3 = do re mi), pégala aquí y se convertirá en un patrón reproducible. También reconoce los puntos de octava y los guiones de notas mantenidas.';

  @override
  String get tutorialHomeBasicsTitle => 'Aprende los términos';

  @override
  String get tutorialHomeBasicsBody =>
      'Una parada más. «Lo esencial» es un glosario en lenguaje sencillo de cada término musical que usa la aplicación. Leamos los cuatro más importantes.';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM significa pulsos por minuto, así que 60 BPM es exactamente un pulso por segundo. Es el número que ajustas con el deslizador de tempo en la página de práctica. La regla general es empezar más lento de lo que te resulte cómodo.';

  @override
  String get tutorialBasicsMeterBody =>
      'El número superior indica cuántos pulsos tiene cada compás, y el pulso 1 siempre lleva el acento. Lo eliges con el botón de compás en la página de práctica. Para la mayoría de la música, 4/4 es la opción segura.';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'La subdivisión parte cada pulso en clics iguales más pequeños: las corcheas dan 2 clics por pulso y las semicorcheas, 4. Actívala cuando tus notas vayan más rápido que el pulso principal.';

  @override
  String get tutorialBasicsNotationBody =>
      'Las mismas notas tienen dos sistemas de nombres y la aplicación acepta ambos: letras occidentales (C D E F G A B) y sargam oriental (S R G M P D N). Las tarjetas cercanas explican además las marcas de octava, las notas mantenidas y los grupos.';

  @override
  String get tutorialHomeReturnTitle => 'Volver a la página principal';

  @override
  String get tutorialHomeReturnBody =>
      'Eso son las cuatro pestañas. Toca «Práctica» tú mismo para volver a la página principal, así siempre sabrás cómo regresar.';

  @override
  String get tutorialStartSessionTitle => 'Empieza cuando quieras';

  @override
  String get tutorialStartSessionBody =>
      'Ahora pulsa «Iniciar metrónomo». Eso abre la página de práctica, donde continúa el tutorial práctico del metrónomo.';

  @override
  String get tutorialHomeSettingsTitle => 'Ajustes y repetición';

  @override
  String get tutorialHomeSettingsBody =>
      'El tema, los colores y el idioma están detrás de este engranaje. Si alguna vez olvidas cómo funciona algo, abre Ajustes y toca «Repetir tutorial». Pulsa Hecho y volveremos a «Práctica».';

  @override
  String get tutorialScoreTitle => 'Partituras en horizontal';

  @override
  String get tutorialScoreBody =>
      'En pantallas grandes en horizontal, carga aquí una imagen o un PDF de partitura y practica con el metrónomo al lado. Puedes hacer zoom, pasar páginas y ver a pantalla completa.';

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
  String get timeSignature => 'Compás';

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
    return 'toca «$tabName» en la barra inferior.';
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

  @override
  String get instrumentPiano => 'Piano A';

  @override
  String get instrumentUprightPiano => 'Piano B';

  @override
  String get instrumentPipa => 'Pipa';

  @override
  String get instrumentRuan => 'Ruan';

  @override
  String get instrumentGuzheng => 'Guzheng';

  @override
  String get instrumentErhu => 'Erhu';

  @override
  String get instrumentFlute => 'Flauta de bambú';

  @override
  String get instrumentShamisen => 'Shamisen';

  @override
  String get instrumentHarmonium => 'Armonio';

  @override
  String get instrumentTabla => 'Tabla';

  @override
  String get instrumentOud => 'Laúd árabe';

  @override
  String get instrumentQanun => 'Qanun';

  @override
  String get instrumentDuduk => 'Duduk';

  @override
  String get instrumentNey => 'Ney';

  @override
  String get instrumentTanbur => 'Tanbur';

  @override
  String get instrumentCelesta => 'Celesta';

  @override
  String get instrumentHarp => 'Arpa';

  @override
  String get instrumentClarinet => 'Clarinete';

  @override
  String get instrumentOboe => 'Oboe';

  @override
  String get instrumentTrumpet => 'Trompeta';

  @override
  String get instrumentFrenchHorn => 'Trompa';

  @override
  String get instrumentAcousticGuitar => 'Guitarra acústica';

  @override
  String get instrumentElectricGuitar => 'Guitarra eléctrica';

  @override
  String get instrumentAcousticBass => 'Bajo acústico';

  @override
  String get instrumentBianzhong => 'Bianzhong';

  @override
  String get instrumentMarimba => 'Marimba';

  @override
  String get regionWestern => 'Occidental';

  @override
  String get regionEastAsian => 'Asia Oriental';

  @override
  String get regionMiddleEastern => 'Medio Oriente';

  @override
  String get regionSouthAsian => 'Asia del Sur';

  @override
  String get regionOther => 'Otros';

  @override
  String get clickSoundClassic => 'Clásico';

  @override
  String get clickSoundQuartz => 'Cuarzo';

  @override
  String get clickSoundStick => 'Baqueta';

  @override
  String get clickSoundPracticePad => 'Pad de práctica';

  @override
  String get clickSoundGlass => 'Vidrio';

  @override
  String get clickSoundMetal => 'Metal';

  @override
  String get clickSoundSnap => 'Chasquido';

  @override
  String get clickSoundClap => 'Palmada';

  @override
  String get clickSoundTambourine => 'Pandereta';

  @override
  String get clickSoundCan => 'Lata';

  @override
  String get clickSoundClickToy => 'Clicker';

  @override
  String get clickSoundWoodBlock => 'Bloque de madera';

  @override
  String get dailyGoal => 'Objetivo diario';

  @override
  String get exampleMajorScaleName => 'Escala mayor ascendente y descendente';

  @override
  String get exampleMajorScaleDescription =>
      'Una escala occidental simple que sube y baja.';

  @override
  String get exampleChandrakaunName => 'Ciclo del raga Chandrakaun';

  @override
  String get exampleChandrakaunDescription =>
      'Un ciclo aroha-avaroha compacto: Sa, Ga bemol, Ma, Dha bemol, Ni.';
}
