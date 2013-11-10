F = {
	CMDBUF_SIZE = 4096,
	CMD_APPEND = 4294967070,
	CMD_BGCOLOR = 4294967049,
	CMD_BITMAP_TRANSFORM = 4294967073,
	CMD_BUTTON = 4294967053,
	CMD_CALIBRATE = 4294967061,
	CMD_CLOCK = 4294967060,
	CMD_COLDSTART = 4294967090,
	CMD_CRC = 4294967043,
	CMD_DIAL = 4294967085,
	CMD_DLSTART = 4294967040,
	CMD_EXECUTE = 4294967047,
	CMD_FGCOLOR = 4294967050,
	CMD_GAUGE = 4294967059,
	CMD_GETMATRIX = 4294967091,
	CMD_GETPOINT = 4294967048,
	CMD_GETPROPS = 4294967077,
	CMD_GETPTR = 4294967075,
	CMD_GRADCOLOR = 4294967092,
	CMD_GRADIENT = 4294967051,
	CMD_HAMMERAUX = 4294967044,
	CMD_IDCT = 4294967046,
	CMD_INFLATE = 4294967074,
	CMD_INTERRUPT = 4294967042,
	CMD_KEYS = 4294967054,
	CMD_LOADIDENTITY = 4294967078,
	CMD_LOADIMAGE = 4294967076,
	CMD_LOGO = 4294967089,
	CMD_MARCH = 4294967045,
	CMD_MEMCPY = 4294967069,
	CMD_MEMCRC = 4294967064,
	CMD_MEMSET = 4294967067,
	CMD_MEMWRITE = 4294967066,
	CMD_MEMZERO = 4294967068,
	CMD_NUMBER = 4294967086,
	CMD_PROGRESS = 4294967055,
	CMD_REGREAD = 4294967065,
	CMD_ROTATE = 4294967081,
	CMD_SCALE = 4294967080,
	CMD_SCREENSAVER = 4294967087,
	CMD_SCROLLBAR = 4294967057,
	CMD_SETFONT = 4294967083,
	CMD_SETMATRIX = 4294967082,
	CMD_SKETCH = 4294967088,
	CMD_SLIDER = 4294967056,
	CMD_SNAPSHOT = 4294967071,
	CMD_SPINNER = 4294967062,
	CMD_STOP = 4294967063,
	CMD_SWAP = 4294967041,
	CMD_TEXT = 4294967052,
	CMD_TOGGLE = 4294967058,
	CMD_TOUCH_TRANSFORM = 4294967072,
	CMD_TRACK = 4294967084,
	CMD_TRANSLATE = 4294967079,

	DECR = 4,
	DECR_WRAP = 7,
	DLSWAP_DONE = 0,
	DLSWAP_FRAME = 2,
	DLSWAP_LINE = 1,
	DST_ALPHA = 3,
	EDGE_STRIP_A = 7,
	EDGE_STRIP_B = 8,
	EDGE_STRIP_L = 6,
	EDGE_STRIP_R = 5,
	EQUAL = 5,
	GEQUAL = 4,
	GREATER = 3,
	INCR = 3,
	INCR_WRAP = 6,
	INT_CMDEMPTY = 32,
	INT_CMDFLAG = 64,
	INT_CONVCOMPLETE = 128,
	INT_PLAYBACK = 16,
	INT_SOUND = 8,
	INT_SWAP = 1,
	INT_TAG = 4,
	INT_TOUCH = 2,
	INVERT = 5,

	KEEP = 1,
	L1 = 1,
	L4 = 2,
	L8 = 3,
	LEQUAL = 2,
	LESS = 1,
	LINEAR_SAMPLES = 0,
	LINES = 3,
	LINE_STRIP = 4,
	NEAREST = 0,
	NEVER = 0,
	NOTEQUAL = 6,
	ONE = 1,
	ONE_MINUS_DST_ALPHA = 5,
	ONE_MINUS_SRC_ALPHA = 4,
	OPT_CENTER = 1536,
	OPT_CENTERX = 512,
	OPT_CENTERY = 1024,
	OPT_FLAT = 256,
	OPT_MONO = 1,
	OPT_NOBACK = 4096,
	OPT_NODL = 2,
	OPT_NOHANDS = 49152,
	OPT_NOHM = 16384,
	OPT_NOPOINTER = 16384,
	OPT_NOSECS = 32768,
	OPT_NOTICKS = 8192,
	OPT_RIGHTX = 2048,
	OPT_SIGNED = 256,
	PALETTED = 8,
	FTPOINTS = 2,
	RECTS = 9,

	RAM_CMD = 1081344,
	RAM_DL = 1048576,
	RAM_G = 0,
	RAM_PAL = 1056768,
	RAM_REG = 1057792,



	REG_ANALOG = 1058104,
	REG_ANA_COMP = 1058160,
	REG_CLOCK = 1057800,
	REG_CMD_DL = 1058028,
	REG_CMD_READ = 1058020,
	REG_CMD_WRITE = 1058024,
	REG_CPURESET = 1057820,
	REG_CRC = 1058152,
	REG_CSPREAD = 1057892,
	REG_CYA0 = 1058000,
	REG_CYA1 = 1058004,
	REG_CYA_TOUCH = 1058100,
	REG_DATESTAMP = 1058108,
	REG_DITHER = 1057884,
	REG_DLSWAP = 1057872,
	REG_FRAMES = 1057796,
	REG_FREQUENCY = 1057804,
	REG_GPIO = 1057936,
	REG_GPIO_DIR = 1057932,
	REG_HCYCLE = 1057832,
	REG_HOFFSET = 1057836,
	REG_HSIZE = 1057840,
	REG_HSYNC0 = 1057844,
	REG_HSYNC1 = 1057848,
	REG_ID = 1057792,
	REG_INT_EN = 1057948,
	REG_INT_FLAGS = 1057944,
	REG_INT_MASK = 1057952,
	REG_MACRO_0 = 1057992,
	REG_MACRO_1 = 1057996,
	REG_OUTBITS = 1057880,
	REG_PCLK = 1057900,
	REG_PCLK_POL = 1057896,
	REG_PLAY = 1057928,
	REG_PLAYBACK_FORMAT = 1057972,
	REG_PLAYBACK_FREQ = 1057968,
	REG_PLAYBACK_LENGTH = 1057960,
	REG_PLAYBACK_LOOP = 1057976,
	REG_PLAYBACK_PLAY = 1057980,
	REG_PLAYBACK_READPTR = 1057964,
	REG_PLAYBACK_START = 1057956,
	REG_PWM_DUTY = 1057988,
	REG_PWM_HZ = 1057984,
	REG_RENDERMODE = 1057808,
	REG_ROMSUB_SEL = 1058016,
	REG_ROTATE = 1057876,
	REG_SNAPSHOT = 1057816,
	REG_SNAPY = 1057812,
	REG_SOUND = 1057924,
	REG_SWIZZLE = 1057888,
	REG_TAG = 1057912,
	REG_TAG_X = 1057904,
	REG_TAG_Y = 1057908,
	REG_TAP_CRC = 1057824,
	REG_TAP_MASK = 1057828,
	REG_TOUCH_ADC_MODE = 1058036,
	REG_TOUCH_CHARGE = 1058040,
	REG_TOUCH_DIRECT_XY = 1058164,
	REG_TOUCH_DIRECT_Z1Z2 = 1058168,
	REG_TOUCH_MODE = 1058032,
	REG_TOUCH_OVERSAMPLE = 1058048,
	REG_TOUCH_RAW_XY = 1058056,
	REG_TOUCH_RZ = 1058060,
	REG_TOUCH_RZTHRESH = 1058052,
	REG_TOUCH_SCREEN_XY = 1058064,
	REG_TOUCH_SETTLE = 1058044,
	REG_TOUCH_TAG = 1058072,
	REG_TOUCH_TAG_XY = 1058068,
	REG_TOUCH_TRANSFORM_A = 1058076,
	REG_TOUCH_TRANSFORM_B = 1058080,
	REG_TOUCH_TRANSFORM_C = 1058084,
	REG_TOUCH_TRANSFORM_D = 1058088,
	REG_TOUCH_TRANSFORM_E = 1058092,
	REG_TOUCH_TRANSFORM_F = 1058096,
	REG_TRACKER = 1085440,
	REG_TRIM = 1058156,
	REG_VCYCLE = 1057852,
	REG_VOFFSET = 1057856,
	REG_VOL_PB = 1057916,
	REG_VOL_SOUND = 1057920,
	REG_VSIZE = 1057860,
	REG_VSYNC0 = 1057864,
	REG_VSYNC1 = 1057868
}
--display list's primitive types
PRIM= {
    BITMAP = 0,
    POINTS = 2,
    LINES = 3,
    LINE_STRIP = 4,
    EDGE_STRIP_R = 5, --right side
    EDGE_STRIP_L = 6, --left side
    EDGE_STRIP_A = 7,--edge strip above
    EDGE_STRIP_B = 8,--edge strip below
    RECTS = 9
}
print("LUA CONSTANTS LOADED.")