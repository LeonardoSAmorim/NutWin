// NutWin - Programa de Apoio a Nutrição(R)
// Copyright (C) 2002-2010 Departamento de Informática em Saúde
// Universidade Federal de São Paulo - UNIFESP <www.unifesp.br>
//
// This file is part of NutWin.
//
// NutWin is free software:  you  can  redistribute  it  and/or
// modify it under the terms of the GNU General Public  License
// as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// Nutwin is distributed in the hope that it  will  be  useful,
// but WITHOUT ANY WARRANTY; without even the implied  warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
// the GNU General Public License for more details.
//
// You should have received a copy of the  GNU  General  Public
// License along with Foobar.
// If not, see <http://www.gnu.org/licenses/>.





 

unit Consts;

interface

resourcestring
  SOpenFileTitle = 'Abrir';
  SAssignError = 'Não é possível atribuir %s para %s';
  SFCreateError = 'Não é possível criar arquivo %s';
  SFOpenError = 'Não é possível abrir arquivo %s';
  SReadError = 'Erro de leitura stream';
  SWriteError = 'Erro de gravação stream';
  SMemoryStreamError = 'Memória esgotada enquanto expandia memória stream';
  SCantWriteResourceStreamError = 'Não é possível gravar em um recurso stream somente para leitura';
  SDuplicateReference = 'WriteObject chamado duas vezes para a mesma instância';
  SClassNotFound = 'Classe %s não encontrada';
  SInvalidImage = 'Formato stream inválido';
  SResNotFound = 'Recurso %s não encontrado';
  SClassMismatch = 'Recurso %s é de uma classe incorreta';
  SListIndexError = 'Índice da lista além dos limites (%d)';
  SListCapacityError = 'Capacidade de lista além dos limites (%d)';
  SListCountError = 'Contador de lista além dos limites (%d)';
  SSortedListError = 'Operação não permitida em lista de string ordenada';
  SDuplicateString = 'Lista de String não permite duplicidades';
  SInvalidTabIndex = 'Índice da pasta além dos limites';
  SInvalidTabPosition = 'Posição de pasta incompatível com o estilo de pasta corrente';
  SInvalidTabStyle = 'Estilo de pasta incompatível com a posição de pasta corrente';
  SDuplicateName = 'Um componente de nome %s já existe';
  SInvalidName = '''''%s'''' não é um nome válido de componente';
  SDuplicateClass = 'Uma classe de nome %s já existe';
  SNoComSupport = '%s não foi registrado como uma classe COM';
  SInvalidInteger = '''''%s'''' não é um valor inteiro válido';
  SLineTooLong = 'Linha muito longa';
  SInvalidPropertyValue = 'Valor de propriedade inválido';
  SInvalidPropertyPath = 'Caminho de propriedade inválido';
  SUnknownProperty = 'Propiedade inexistente';
  SReadOnlyProperty = 'Propiedade somente para leitura';
  SPropertyException = 'Erro de leitura %s.%s: %s';
  SAncestorNotFound = 'Ancestral para ''%s'' não encontrado';
  SInvalidBitmap = 'Imagem do Bitmap inválida';
  SInvalidIcon = 'Imagem do Ícone image inválida';
  SInvalidMetafile = 'Metafile inválido';
  SInvalidPixelFormat = 'Formato do pixel inválido';
  SBitmapEmpty = 'Bitmap vazio';
  SScanLine = 'Scan line index out of range';
  SChangeIconSize = 'Não é possível mudar o tamanho de um ícone';
  SOleGraphic = 'Operação inválida sobre TOleGraphic';
  SUnknownExtension = 'Extensão de arquivo picture desconhecida (.%s)';
  SUnknownClipboardFormat = 'Formato de clipboard não suportado';
  SOutOfResources = 'Recursos de sistema esgotados';
  SNoCanvasHandle = 'Canvas não permite desenho';
  SInvalidImageSize = 'Tamanho da imagem inválido';
  STooManyImages = 'Muitas imagens';
  SDimsDoNotMatch = 'Dimensões das imagens em desacordo com a lista de dimensões de imagens';
  SInvalidImageList = 'ImageList inválida';
  SReplaceImage = 'Incapaz de substituir imagem';
  SImageIndexError = 'Índice de ImageList inválido';
  SImageReadFail = 'Falha na leitura do ImageList data do stream';
  SImageWriteFail = 'Falha na gravação do ImageList data para o stream';
  SWindowDCError = 'Erro na criação de dispositivo de contexto de janela';
  SClientNotSet = 'Cliente de TDrag não inicializado';
  SWindowClass = 'Error creating window class';
  SWindowCreate = 'Erro na criação de janela';
  SCannotFocus = 'Não é possível focar uma janela desabilitada ou invisível';
  SParentRequired = 'Controle ''%s'' não tem janela ancestral';
  SMDIChildNotVisible = 'Não é possível esconder um MDI Child Form';
  SVisibleChanged = 'Não é possível mudar Visible em OnShow ou OnHide';
  SCannotShowModal = 'Não é possível fazer uma janela modal visível';
  SScrollBarRange = 'Propriedade Scrollbar além dos limites';
  SPropertyOutOfRange = 'Propriedade %s além dos limites';
  SMenuIndexError = 'Índice do Menu além dos limites';
  SMenuReinserted = 'Menu inserido duas vezes';
  SMenuNotFound = 'Sub-menu não está no menu';
  SNoTimers = 'Não existem Timers suficientes à disposição';
  SNotPrinting = 'A impressora não está imprimindo no momento';
  SPrinting = 'Impressão em execução';
  SPrinterIndexError = 'Índice da impressora está além dos limites';
  SInvalidPrinter = 'Impressora selecionada não é válida';
  SDeviceOnPort = '%s em %s';
  SGroupIndexTooLow = 'GroupIndex não pode ser menor que o GroupIndex do item de menu anterior';
  STwoMDIForms = 'Não é possivel ter mais de um formulário MDI por aplicativo';
  SNoMDIForm = 'Não é possível criar formulário. Nenhum formulário MDI está ativo no momento';
  SRegisterError = 'Registro de componente inválido';
  SImageCanvasNeedsBitmap = 'Só é possível alterar uma imagem se ela contem um Bitmap';
  SControlParentSetToSelf = 'O controle não pode ter a si mesmo como ancestral';
  SOKButton = 'OK';
  SCancelButton = 'Cancelar';
  SYesButton = '&Sim';
  SNoButton = '&Não';
  SHelpButton = 'Aj&uda';
  SCloseButton = '&Fechar';
  SIgnoreButton = '&Ignorar';
  SRetryButton = '&Repetir';
  SAbortButton = 'Abortar';
  SAllButton = '&Todos';

  SCannotDragForm = 'Não é possível arrastar o form';
  SPutObjectError = 'PutObject para item indefinido';
  SCardDLLNotLoaded = 'Não é possível carregar CARDS.DLL';
  SDuplicateCardId = 'Encontrado CardId duplicado';

  SDdeErr = 'Um erro retornou do DDE  ($0%x)';
  SDdeConvErr = 'Erro DDE - conversão não estabelecida ($0%x)';
  SDdeMemErr = 'Erro ocorreu quando DDE esgotou a memória ($0%x)';
  SDdeNoConnect = 'Impossibilitado de conectar conversão DDE';

  SFB = 'FB';
  SFG = 'FG';
  SBG = 'BG';
  SOldTShape = 'Não é possível carregar versão antiga de TShape';
  SVMetafiles = 'Metafiles';
  SVEnhMetafiles = 'Enhanced Metafiles';
  SVIcons = 'Ícones';
  SVBitmaps = 'Bitmaps';
  SGridTooLarge = 'Grid muito grande para operação';
  STooManyDeleted = 'Muitas linhas ou colunas deletadas';
  SIndexOutOfRange = 'Índice de Grid fora do intervalo';
  SFixedColTooBig = 'Contador fixo de coluna deve ser menor do que o contador de coluna';
  SFixedRowTooBig = 'Contador fixo de linha deve ser menor do que o contador de linha';
  SInvalidStringGridOp = 'Não se pode inserir ou deletar linhas do grid';
  SParseError = '%s em linha %d';
  SIdentifierExpected = 'Identificador esperado';
  SStringExpected = 'String esperada';
  SNumberExpected = 'Número esperado';
  SCharExpected = '''''%s'''' esperado(a)';
  SSymbolExpected = '%s esperado(a)';
  SInvalidNumber = 'Valor numérico inválido';
  SInvalidString = 'Constante string inválida';
  SInvalidProperty = 'Valor de propriedade inválido';
  SInvalidBinary = 'Valor binário inválido';
  SOutlineIndexError = 'Índice Outline não encontrado';
  SOutlineExpandError = 'Ancestral deve ser expandido';
  SInvalidCurrentItem = 'Valor inválido para o item corrente';
  SMaskErr = 'Valor de entrada inválido';
  SMaskEditErr = 'Valor de entrada inválido. Use a tecla escape para abandonar as alterações';
  SOutlineError = 'Índice outline inválido';
  SOutlineBadLevel = 'Nível de atribuição incorreto';
  SOutlineSelection = 'Seleção inválida';
  SOutlineFileLoad = 'Erro na carga do arquivo';
  SOutlineLongLine = 'Linha muito longa';
  SOutlineMaxLevels = 'Profundidade outline máxima excedida';

  SMsgDlgWarning = 'Aviso';
  SMsgDlgError = 'Erro';
  SMsgDlgInformation = 'Informação';
  SMsgDlgConfirm = 'Confirmação';
  SMsgDlgYes = '&Sim';
  SMsgDlgNo = '&Não';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Cancelar';
  SMsgDlgHelp = 'Aj&uda';
  SMsgDlgHelpNone = 'Nenhuma ajuda disponível';
  SMsgDlgHelpHelp = 'Ajuda';
  SMsgDlgAbort = '&Abortar';
  SMsgDlgRetry = '&Repetir';
  SMsgDlgIgnore = '&Ignorar';
  SMsgDlgAll = '&Todos';
  SMsgDlgNoToAll = 'Nã&o para Todos';
  SMsgDlgYesToAll = 'S&im para Todos';

  SmkcBkSp = 'BkSp';
  SmkcTab = 'Tab';
  SmkcEsc = 'Esc';
  SmkcEnter = 'Enter';
  SmkcSpace = 'Space';
  SmkcPgUp = 'PgUp';
  SmkcPgDn = 'PgDn';
  SmkcEnd = 'End';
  SmkcHome = 'Home';
  SmkcLeft = 'Left';
  SmkcUp = 'Up';
  SmkcRight = 'Right';
  SmkcDown = 'Down';
  SmkcIns = 'Ins';
  SmkcDel = 'Del';
  SmkcShift = 'Shift+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';

  srUnknown = '(Desconhecido)';
  srNone = '(Nenhum)';
  SOutOfRange = 'Valor deve estar entre %d e %d';
  SCannotCreateName = 'Não é possível criar um nome de método Default para um componente sem nome';

  SDateEncodeError = 'Argumento para codificação de data inválido';
  STimeEncodeError = 'Argumento para codificação de hora inválido';
  SInvalidDate = '''''%s'''' não é uma data válida';
  SInvalidTime = '''''%s'''' não é uma hora válida';
  SInvalidDateTime = '''''%s'''' is not a valid date and time';
  SInvalidFileName = 'Nome de arquivo inválido - %s';
  SDefaultFilter = 'Todos os arquivos (*.*)|*.*';
  sAllFilter = 'Todos';
  SNoVolumeLabel = ': [ - nenhum nome de volume - ]';
  SInsertLineError = 'Impossibilitado de inserir uma linha';

  SConfirmCreateDir = 'O diretório especificado não existe. Pode ser criado?';
  SSelectDirCap = 'Selecione diretório';
  SCannotCreateDir = 'Impossibilitado de criar diretório';
  SDirNameCap = '&Nome de Diretório:';
  SDrivesCap = 'D&rives:';
  SDirsCap = '&Diretórios:';
  SFilesCap = '&Arquivos: (*.*)';
  SNetworkCap = '&Rede...';

  SColorPrefix = 'Color';
  SColorTags = 'ABCDEFGHIJKLMNOP';

  SInvalidClipFmt = 'Formato de clipboard inválido';
  SIconToClipboard = 'Clipboard não suporta ícones';
  SCannotOpenClipboard = 'Não é possível abrir o clipboard';

  SDefault = 'Default';

  SInvalidMemoSize = 'Texto excede a capacidade de memória';
  SCustomColors = 'Cores customizadas';
  SInvalidPrinterOp = 'Operação não suportada pela impressora selecionada';
  SNoDefaultPrinter = 'Não existe impressora default selecionada no momento';

  SIniFileWriteError = 'Impossibilitado de gravar em %s';

  SBitsIndexError = 'Índice Bits fora do intervalo';

  SUntitled = '(Sem título)';

  SInvalidRegType = 'Tipo de dado inválido para ''%s''';
  SRegCreateFailed = 'Falha na criação de chave %s';
  SRegSetDataFailed = 'Falha na configuração de dados para ''%s''';
  SRegGetDataFailed = 'Falha na obtenção de dados para ''%s''';

  SUnknownConversion = 'Extensão de conversão de arquivo RichEdit desconhecida (.%s)';
  SDuplicateMenus = 'Menu ''%s'' já está sendo usado por outro form';

  SPictureLabel = 'Picture:';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Visualização';

  SCannotOpenAVI = 'Não é possível abrir AVI';

  SNotOpenErr = 'Nenhum dispositivo MCI aberto';
  SMPOpenFilter = 'Todos os arquivos (*.*)|*.*|Arquivos Wave (*.wav)|*.wav|Arquivos Midi (*.mid)|*.mid|Video para Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'AVIVideo';
  SMCICDAudio = 'CDAudio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'DigitalVideo';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Outro';
  SMCIOverlay = 'Overlay';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Sequencer';
  SMCIVCR = 'VCR';
  SMCIVideodisc = 'Videodisc';
  SMCIWaveAudio = 'WaveAudio';
  SMCIUnknownError = 'Código de erro desconhecido';

  SBoldItalicFont = 'Negrito Itálico';
  SBoldFont = 'Negrito';
  SItalicFont = 'Itálico';
  SRegularFont = 'Normal';

  SPropertiesVerb = 'Propriedades';

  sWindowsSocketError = 'Erro de conector Windows: %s (%d), na API ''%s''';
  sAsyncSocketError = 'Erro de conector assíncrono %d';
  sNoAddress = 'Nenhum endereço especificado';
  sCannotListenOnOpen = 'Não é possível ouvir em um conector aberto';
  sCannotCreateSocket = 'Não é possível criar um novo conector';
  sSocketAlreadyOpen = 'Socket already open';
  sCantChangeWhileActive = 'Não é possível alterar o valor enquanto o conector estiver ativo';
  sSocketMustBeBlocking = 'O conector deve estar em modo de bloqueio';
  sSocketIOError = '%s erro %d, %s';
  sSocketRead = 'Ler';
  sSocketWrite = 'Gravar';

  SServiceFailed = 'Falha de serviço em %s: %s';
  SExecute = 'executar';
  SStart = 'iniciar';
  SStop = 'parar';
  SPause = 'pausa';
  SContinue = 'continuar';
  SInterrogate = 'perguntar';
  SShutdown = 'desligar';
  SCustomError = 'Falha de serviço em mensagem customizada(%d): %s';
  SServiceInstallOK = 'Serviço instalado com sucesso';
  SServiceInstallFailed = 'Serviço "%s" falhou na instalação com o erro: "%s"';
  SServiceUninstallOK = 'Serviço desinstalado com sucesso';
  SServiceUninstallFailed = 'Serviço "%s" falhou na desinstalação com o erro: "%s"';

  SInvalidActionRegistration = 'Ação de registro inválida';
  SInvalidActionUnregistration = 'Ação de retirada de registro inválida';
  SInvalidActionEnumeration = 'Ação de enumeração inválida';
  SInvalidActionCreation = 'Ação de criação inválida';
  
  SDockedCtlNeedsName = 'Controle flutuante tem que ter um nome';
  SDockTreeRemoveError = 'Erro na remoção do controle da árvore flutuante';
  SDockZoneNotFound = ' - Zona flutuante não encontrada';
  SDockZoneHasNoCtl = ' - Zona flutuante não tem nenhum controle';

  SAllCommands = 'Todos os comandos';

implementation

end.
