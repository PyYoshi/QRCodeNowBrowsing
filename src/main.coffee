# TODO: オプション追加(QrOptionsをユーザが任意に変更可能なようにする)

class QrUtils
  @DEFAULT_QR_SIZE_WIDTH = 128
  @DEFAULT_QR_SIZE_HEIGHT = 128
  @DEFAULT_QR_COLOR_FOREGROUND = '#000000'
  @DEFAULT_QR_COLOR_BACKGROUND = '#ffffff'
  @DEFAULT_QR_ELEMENT_ID = 'qrcanvas'

  # Support Type Number: 1 to 10
  # L: Level L (Low)	7% of codewords can be restored.
  # M:  Level M (Medium)	15% of codewords can be restored.
  # Q: Level Q (Quartile)[36]	25% of codewords can be restored.
  # H:  Level H (High)	30% of codewords can be restored.
  # detail: http://www.qrcode.com/en/about/version.html
  @DEFAULT_QR_TYPE_NUMBER = 10
  @DEFAULT_QR_CORRECT_LEVEL = 'L'

  constructor: ()->
    return

  #  make canvas element
  #  based: https://github.com/jeromeetienne/jquery-qrcode/blob/master/src/jquery.qrcode.js
  #  @param [String] text
  #  @param [QrOptions] options
  @makeCanvas: (text, options=false)->

    if !options
      options = new QrOptions()

    console.log(options)

    # create qrcode data
    qr = qrcode(options.typeNumber, options.correctLevel)
    qr.addData(text)
    qr.make()

    # create canvas element
    canvas = document.createElement('canvas')
    canvas.width = options.width
    canvas.height = options.height
    canvas.id = options.elementId
    ctx = canvas.getContext('2d')

    # compute tileW/tileH based on options.width/options.height
    tileW = options.width  / qr.getModuleCount()
    tileH = options.height / qr.getModuleCount()

    # draw in canvas
    for row in [0..qr.getModuleCount() - 1]
      for col in [0..qr.getModuleCount() - 1]
        ctx.fillStyle = if qr.isDark(row, col) then options.foreground else options.background
        w = (Math.ceil((col + 1) * tileW) - Math.floor(col * tileW))
        h = (Math.ceil((row + 1) * tileW) - Math.floor(row * tileW))
        ctx.fillRect(Math.round(col * tileW), Math.round(row * tileH), w, h)

    return canvas

class QrOptions
  width: QrUtils.DEFAULT_QR_SIZE_WIDTH
  height: QrUtils.DEFAULT_QR_SIZE_HEIGHT
  foreground: QrUtils.DEFAULT_QR_COLOR_FOREGROUND
  background: QrUtils.DEFAULT_QR_COLOR_BACKGROUND
  typeNumber: QrUtils.DEFAULT_QR_TYPE_NUMBER
  elementId: QrUtils.DEFAULT_QR_ELEMENT_ID
  correctLevel: QrUtils.DEFAULT_QR_CORRECT_LEVEL

  constructor: ()->
    return

class CrxPopup
  constructor: ()->
    return

  main: ()->
    chrome.tabs.getSelected(
      null,
      (tab)->
        title = tab.title
        url = tab.url
        qrtext = title + '\n' + url
        console.log(qrtext)
        canvas = QrUtils.makeCanvas(qrtext)
        $(canvas).appendTo('#qrcode')
        console.log(canvas.toDataURL())
        return
    )
    return

$ ->
  crxPopup = new CrxPopup()
  crxPopup.main()
