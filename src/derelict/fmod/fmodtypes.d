module derelict.fmod.fmodtypes;


const FMOD_VERSION = 0x00043004;


alias int FMOD_BOOL;
typedef void FMOD_SYSTEM;
typedef void FMOD_SOUND;
typedef void FMOD_CHANNEL;
typedef void FMOD_CHANNELGROUP;
typedef void FMOD_SOUNDGROUP;
typedef void FMOD_REVERB;
typedef void FMOD_DSP;
typedef void FMOD_DSPCONNECTION;
typedef void FMOD_POLYGON;
typedef void FMOD_GEOMETRY;
typedef void FMOD_SYNCPOINT;
alias uint FMOD_MODE;
alias uint FMOD_TIMEUNIT;
alias uint FMOD_INITFLAGS;
alias uint FMOD_CAPS;
alias uint FMOD_DEBUGLEVEL;
alias uint FMOD_MEMORY_TYPE;


struct FMOD_VECTOR
{
    float x;
    float y;
    float z;
}

struct FMOD_GUID
{
    uint   Data1;       /* Specifies the first 8 hexadecimal digits of the GUID */
    ushort Data2;       /* Specifies the first group of 4 hexadecimal digits.   */
    ushort Data3;       /* Specifies the second group of 4 hexadecimal digits.  */
    ubyte[8] Data4;     /* Array of 8 bytes. The first 2 bytes contain the third group of 4 hexadecimal digits. The remaining 6 bytes contain the final 12 hexadecimal digits. */
}

typedef int FMOD_RESULT;
enum : FMOD_RESULT
{
    FMOD_OK,
    FMOD_ERR_ALREADYLOCKED,
    FMOD_ERR_BADCOMMAND,
    FMOD_ERR_CDDA_DRIVERS,
    FMOD_ERR_CDDA_INIT,
    FMOD_ERR_CDDA_INVALID_DEVICE,
    FMOD_ERR_CDDA_NOAUDIO,
    FMOD_ERR_CDDA_NODEVICES,
    FMOD_ERR_CDDA_NODISC,
    FMOD_ERR_CDDA_READ,
    FMOD_ERR_CHANNEL_ALLOC,
    FMOD_ERR_CHANNEL_STOLEN,
    FMOD_ERR_COM,
    FMOD_ERR_DMA,
    FMOD_ERR_DSP_CONNECTION,
    FMOD_ERR_DSP_FORMAT,
    FMOD_ERR_DSP_NOTFOUND,
    FMOD_ERR_DSP_RUNNING,
    FMOD_ERR_DSP_TOOMANYCONNECTIONS,
    FMOD_ERR_FILE_BAD,
    FMOD_ERR_FILE_COULDNOTSEEK,
    FMOD_ERR_FILE_DISKEJECTED,
    FMOD_ERR_FILE_EOF,
    FMOD_ERR_FILE_NOTFOUND,
    FMOD_ERR_FILE_UNWANTED,
    FMOD_ERR_FORMAT,
    FMOD_ERR_HTTP,
    FMOD_ERR_HTTP_ACCESS,
    FMOD_ERR_HTTP_PROXY_AUTH,
    FMOD_ERR_HTTP_SERVER_ERROR,
    FMOD_ERR_HTTP_TIMEOUT,
    FMOD_ERR_INITIALIZATION,
    FMOD_ERR_INITIALIZED,
    FMOD_ERR_INTERNAL,
    FMOD_ERR_INVALID_ADDRESS,
    FMOD_ERR_INVALID_FLOAT,
    FMOD_ERR_INVALID_HANDLE,
    FMOD_ERR_INVALID_PARAM,
    FMOD_ERR_INVALID_POSITION,
    FMOD_ERR_INVALID_SPEAKER,
    FMOD_ERR_INVALID_SYNCPOINT,
    FMOD_ERR_INVALID_VECTOR,
    FMOD_ERR_IRX,
    FMOD_ERR_MAXAUDIBLE,
    FMOD_ERR_MEMORY,
    FMOD_ERR_MEMORY_CANTPOINT,
    FMOD_ERR_MEMORY_IOP,
    FMOD_ERR_MEMORY_SRAM,
    FMOD_ERR_NEEDS2D,
    FMOD_ERR_NEEDS3D,
    FMOD_ERR_NEEDSHARDWARE,
    FMOD_ERR_NEEDSSOFTWARE,
    FMOD_ERR_NET_CONNECT,
    FMOD_ERR_NET_SOCKET_ERROR,
    FMOD_ERR_NET_URL,
    FMOD_ERR_NET_WOULD_BLOCK,
    FMOD_ERR_NOTREADY,
    FMOD_ERR_OUTPUT_ALLOCATED,
    FMOD_ERR_OUTPUT_CREATEBUFFER,
    FMOD_ERR_OUTPUT_DRIVERCALL,
    FMOD_ERR_OUTPUT_ENUMERATION,
    FMOD_ERR_OUTPUT_FORMAT,
    FMOD_ERR_OUTPUT_INIT,
    FMOD_ERR_OUTPUT_NOHARDWARE,
    FMOD_ERR_OUTPUT_NOSOFTWARE,
    FMOD_ERR_PAN,
    FMOD_ERR_PLUGIN,
    FMOD_ERR_PLUGIN_INSTANCES,
    FMOD_ERR_PLUGIN_MISSING,
    FMOD_ERR_PLUGIN_RESOURCE,
    FMOD_ERR_PRELOADED,
    FMOD_ERR_PROGRAMMERSOUND,
    FMOD_ERR_RECORD,
    FMOD_ERR_REVERB_INSTANCE,
    FMOD_ERR_SUBSOUND_ALLOCATED,
    FMOD_ERR_SUBSOUND_CANTMOVE,
    FMOD_ERR_SUBSOUND_MODE,
    FMOD_ERR_SUBSOUNDS,
    FMOD_ERR_TAGNOTFOUND,
    FMOD_ERR_TOOMANYCHANNELS,
    FMOD_ERR_UNIMPLEMENTED,
    FMOD_ERR_UNINITIALIZED,
    FMOD_ERR_UNSUPPORTED,
    FMOD_ERR_UPDATE,
    FMOD_ERR_VERSION,

    FMOD_ERR_EVENT_FAILED,
    FMOD_ERR_EVENT_INFOONLY,
    FMOD_ERR_EVENT_INTERNAL,
    FMOD_ERR_EVENT_MAXSTREAMS,
    FMOD_ERR_EVENT_MISMATCH,
    FMOD_ERR_EVENT_NAMECONFLICT,
    FMOD_ERR_EVENT_NOTFOUND,
    FMOD_ERR_EVENT_NEEDSSIMPLE,
    FMOD_ERR_EVENT_GUIDCONFLICT,
    FMOD_ERR_EVENT_ALREADY_LOADED,

    FMOD_ERR_MUSIC_UNINITIALIZED,
    FMOD_ERR_MUSIC_NOTFOUND,
    FMOD_ERR_MUSIC_NOCALLBACK,

    FMOD_RESULT_FORCEINT = 65536
}


typedef int FMOD_OUTPUTTYPE;
enum : FMOD_OUTPUTTYPE
{
    FMOD_OUTPUTTYPE_AUTODETECT,

    FMOD_OUTPUTTYPE_UNKNOWN,
    FMOD_OUTPUTTYPE_NOSOUND,
    FMOD_OUTPUTTYPE_WAVWRITER,
    FMOD_OUTPUTTYPE_NOSOUND_NRT,
    FMOD_OUTPUTTYPE_WAVWRITER_NRT,

    FMOD_OUTPUTTYPE_DSOUND,
    FMOD_OUTPUTTYPE_WINMM,
    FMOD_OUTPUTTYPE_OPENAL,
    FMOD_OUTPUTTYPE_WASAPI,
    FMOD_OUTPUTTYPE_ASIO,
    FMOD_OUTPUTTYPE_OSS,
    FMOD_OUTPUTTYPE_ALSA,
    FMOD_OUTPUTTYPE_ESD,
    FMOD_OUTPUTTYPE_COREAUDIO,
    FMOD_OUTPUTTYPE_PS2,
    FMOD_OUTPUTTYPE_PS3,
    FMOD_OUTPUTTYPE_XBOX360,
    FMOD_OUTPUTTYPE_PSP,
	FMOD_OUTPUTTYPE_WII,

    FMOD_OUTPUTTYPE_MAX,
    FMOD_OUTPUTTYPE_FORCEINT = 65536
}


enum {
	FMOD_CAPS_NONE = 0x00000000,
	FMOD_CAPS_HARDWARE = 0x00000001,
	FMOD_CAPS_HARDWARE_EMULATED = 0x00000002,
	FMOD_CAPS_OUTPUT_MULTICHANNEL = 0x00000004,
	FMOD_CAPS_OUTPUT_FORMAT_PCM8 = 0x00000008,
	FMOD_CAPS_OUTPUT_FORMAT_PCM16 = 0x00000010,
	FMOD_CAPS_OUTPUT_FORMAT_PCM24 = 0x00000020,
	FMOD_CAPS_OUTPUT_FORMAT_PCM32 = 0x00000040,
	FMOD_CAPS_OUTPUT_FORMAT_PCMFLOAT = 0x00000080,
    FMOD_CAPS_REVERB_EAX2 = 0x00000100,
    FMOD_CAPS_REVERB_EAX3 = 0x00000200,
    FMOD_CAPS_REVERB_EAX4 = 0x00000400,
    FMOD_CAPS_REVERB_EAX5 = 0x00000800,
    FMOD_CAPS_REVERB_I3DL2 = 0x00001000,
    FMOD_CAPS_REVERB_LIMITED = 0x00002000,
}


enum {
	FMOD_DEBUG_LEVEL_NONE = 0x00000000,
	FMOD_DEBUG_LEVEL_LOG = 0x00000001,
	FMOD_DEBUG_LEVEL_ERROR = 0x00000002,
	FMOD_DEBUG_LEVEL_WARNING = 0x00000004,
	FMOD_DEBUG_LEVEL_HINT = 0x00000008,
	FMOD_DEBUG_LEVEL_ALL = 0x000000FF,
	FMOD_DEBUG_TYPE_MEMORY = 0x00000100,
	FMOD_DEBUG_TYPE_THREAD = 0x00000200,
	FMOD_DEBUG_TYPE_FILE = 0x00000400,
	FMOD_DEBUG_TYPE_NET = 0x00000800,
	FMOD_DEBUG_TYPE_EVENT = 0x00001000,
	FMOD_DEBUG_TYPE_ALL = 0x0000FFFF,
	FMOD_DEBUG_DISPLAY_TIMESTAMPS = 0x01000000,
	FMOD_DEBUG_DISPLAY_LINENUMBERS = 0x02000000,
	FMOD_DEBUG_DISPLAY_COMPRESS = 0x04000000,
    FMOD_DEBUG_DISPLAY_THREAD = 0x08000000,
	FMOD_DEBUG_DISPLAY_ALL = 0x0F000000,
	FMOD_DEBUG_ALL = 0xFFFFFFFF,
}


enum {
    FMOD_MEMORY_NORMAL = 0x00000000,
    FMOD_MEMORY_STREAM_FILE = 0x00000001,
    FMOD_MEMORY_STREAM_DECODE = 0x00000002,
    FMOD_MEMORY_XBOX360_PHYSICAL = 0x00100000,
    FMOD_MEMORY_PERSISTENT = 0x00200000,
    FMOD_MEMORY_SECONDARY = 0x00400000,
    FMOD_MEMORY_ALL = 0xFFFFFFFF,
}


typedef int FMOD_SPEAKERMODE;
enum : FMOD_SPEAKERMODE
{
    FMOD_SPEAKERMODE_RAW,
    FMOD_SPEAKERMODE_MONO,
    FMOD_SPEAKERMODE_STEREO,
    FMOD_SPEAKERMODE_QUAD,
    FMOD_SPEAKERMODE_SURROUND,
    FMOD_SPEAKERMODE_5POINT1,
    FMOD_SPEAKERMODE_7POINT1,
    FMOD_SPEAKERMODE_PROLOGIC,
    FMOD_SPEAKERMODE_MAX,
    FMOD_SPEAKERMODE_FORCEINT = 65536,
}


typedef int FMOD_SPEAKER;
enum : FMOD_SPEAKER
{
    FMOD_SPEAKER_FRONT_LEFT,
    FMOD_SPEAKER_FRONT_RIGHT,
    FMOD_SPEAKER_FRONT_CENTER,
    FMOD_SPEAKER_LOW_FREQUENCY,
    FMOD_SPEAKER_BACK_LEFT,
    FMOD_SPEAKER_BACK_RIGHT,
    FMOD_SPEAKER_SIDE_LEFT,
    FMOD_SPEAKER_SIDE_RIGHT,
    FMOD_SPEAKER_MAX,
    FMOD_SPEAKER_MONO = FMOD_SPEAKER_FRONT_LEFT,
    FMOD_SPEAKER_NULL = FMOD_SPEAKER_MAX,
    FMOD_SPEAKER_SBL = FMOD_SPEAKER_SIDE_LEFT,
    FMOD_SPEAKER_SBR = FMOD_SPEAKER_SIDE_RIGHT,
    FMOD_SPEAKER_FORCEINT = 65536,
}


typedef int FMOD_PLUGINTYPE;
enum : FMOD_PLUGINTYPE
{
    FMOD_PLUGINTYPE_OUTPUT,
    FMOD_PLUGINTYPE_CODEC,
    FMOD_PLUGINTYPE_DSP,
    FMOD_PLUGINTYPE_MAX,
    FMOD_PLUGINTYPE_FORCEINT = 65536,
}


enum {
    FMOD_INIT_NORMAL = 0x00000000,
    FMOD_INIT_STREAM_FROM_UPDATE = 0x00000001,
    FMOD_INIT_3D_RIGHTHANDED = 0x00000002,
    FMOD_INIT_SOFTWARE_DISABLE = 0x00000004,
    FMOD_INIT_SOFTWARE_OCCLUSION = 0x00000008,
    FMOD_INIT_SOFTWARE_HRTF = 0x00000010,
    FMOD_INIT_SOFTWARE_REVERB_LOWMEM = 0x00000040,
    FMOD_INIT_ENABLE_PROFILE = 0x00000020,
    FMOD_INIT_VOL0_BECOMES_VIRTUAL = 0x00000080,
    FMOD_INIT_WASAPI_EXCLUSIVE = 0x00000100,
    FMOD_INIT_DSOUND_HRTFNONE = 0x00000200,
    FMOD_INIT_DSOUND_HRTFLIGHT = 0x00000400,
    FMOD_INIT_DSOUND_HRTFFULL = 0x00000800,
    FMOD_INIT_PS2_DISABLECORE0REVERB = 0x00010000,
    FMOD_INIT_PS2_DISABLECORE1REVERB = 0x00020000,
    FMOD_INIT_PS2_DONTUSESCRATCHPAD = 0x00040000,
    FMOD_INIT_PS2_SWAPDMACHANNELS = 0x00080000,
    FMOD_INIT_PS3_PREFERDTS = 0x00800000,
    FMOD_INIT_PS3_FORCE2CHLPCM = 0x01000000,
    FMOD_INIT_WII_DISABLEDOLBY = 0x00100000,
    FMOD_INIT_SYSTEM_MUSICMUTENOTPAUSE = 0x00200000,
    FMOD_INIT_SYNCMIXERWITHUPDATE = 0x00400000,
    FMOD_INIT_DTS_NEURALSURROUND = 0x02000000,
    FMOD_INIT_GEOMETRY_USECLOSEST = 0x04000000,
    FMOD_INIT_DISABLE_MYEARS = 0x08000000,
}


typedef int FMOD_SOUND_TYPE;
enum : FMOD_SOUND_TYPE
{
    FMOD_SOUND_TYPE_UNKNOWN,
    FMOD_SOUND_TYPE_AAC,
    FMOD_SOUND_TYPE_AIFF,
    FMOD_SOUND_TYPE_ASF,
    FMOD_SOUND_TYPE_AT3,
    FMOD_SOUND_TYPE_CDDA,
    FMOD_SOUND_TYPE_DLS,
    FMOD_SOUND_TYPE_FLAC,
    FMOD_SOUND_TYPE_FSB,
    FMOD_SOUND_TYPE_GCADPCM,
    FMOD_SOUND_TYPE_IT,
    FMOD_SOUND_TYPE_MIDI,
    FMOD_SOUND_TYPE_MOD,
    FMOD_SOUND_TYPE_MPEG,
    FMOD_SOUND_TYPE_OGGVORBIS,
    FMOD_SOUND_TYPE_PLAYLIST,
    FMOD_SOUND_TYPE_RAW,
    FMOD_SOUND_TYPE_S3M,
    FMOD_SOUND_TYPE_SF2,
    FMOD_SOUND_TYPE_USER,
    FMOD_SOUND_TYPE_WAV,
    FMOD_SOUND_TYPE_XM,
    FMOD_SOUND_TYPE_XMA,
    FMOD_SOUND_TYPE_VAG,
    FMOD_SOUND_TYPE_MAX,
    FMOD_SOUND_TYPE_FORCEINT = 65536,
}


typedef int FMOD_SOUND_FORMAT;
enum : FMOD_SOUND_FORMAT
{
    FMOD_SOUND_FORMAT_NONE,
    FMOD_SOUND_FORMAT_PCM8,
    FMOD_SOUND_FORMAT_PCM16,
    FMOD_SOUND_FORMAT_PCM24,
    FMOD_SOUND_FORMAT_PCM32,
    FMOD_SOUND_FORMAT_PCMFLOAT,
    FMOD_SOUND_FORMAT_GCADPCM,
    FMOD_SOUND_FORMAT_IMAADPCM,
    FMOD_SOUND_FORMAT_VAG,
    FMOD_SOUND_FORMAT_XMA,
    FMOD_SOUND_FORMAT_MPEG,
    FMOD_SOUND_FORMAT_CELT,

    FMOD_SOUND_FORMAT_MAX,
    FMOD_SOUND_FORMAT_FORCEINT = 65536,
}


enum {
	FMOD_DEFAULT = 0x00000000,
	FMOD_LOOP_OFF = 0x00000001,
	FMOD_LOOP_NORMAL = 0x00000002,
	FMOD_LOOP_BIDI = 0x00000004,
	FMOD_2D = 0x00000008,
	FMOD_3D = 0x00000010,
	FMOD_HARDWARE = 0x00000020,
	FMOD_SOFTWARE = 0x00000040,
	FMOD_CREATESTREAM = 0x00000080,
	FMOD_CREATESAMPLE = 0x00000100,
	FMOD_CREATECOMPRESSEDSAMPLE = 0x00000200,
	FMOD_OPENUSER = 0x00000400,
	FMOD_OPENMEMORY = 0x00000800,
	FMOD_OPENMEMORY_POINT = 0x10000000,
	FMOD_OPENRAW = 0x00001000,
	FMOD_OPENONLY = 0x00002000,
	FMOD_ACCURATETIME = 0x00004000,
	FMOD_MPEGSEARCH = 0x00008000,
	FMOD_NONBLOCKING = 0x00010000,
	FMOD_UNIQUE = 0x00020000,
	FMOD_3D_HEADRELATIVE = 0x00040000,
	FMOD_3D_WORLDRELATIVE = 0x00080000,
	FMOD_3D_LOGROLLOFF = 0x00100000,
	FMOD_3D_LINEARROLLOFF = 0x00200000,
	FMOD_3D_CUSTOMROLLOFF = 0x04000000,
	FMOD_3D_IGNOREGEOMETRY = 0x40000000,
	FMOD_CDDA_FORCEASPI = 0x00400000,
	FMOD_CDDA_JITTERCORRECT = 0x00800000,
	FMOD_UNICODE = 0x01000000,
	FMOD_IGNORETAGS = 0x02000000,
	FMOD_LOWMEM = 0x08000000,
	FMOD_LOADSECONDARYRAM = 0x20000000,
    FMOD_VIRTUAL_PLAYFROMSTART = 0x80000000,
}


typedef int FMOD_OPENSTATE;
enum : FMOD_OPENSTATE
{
    FMOD_OPENSTATE_READY,
    FMOD_OPENSTATE_LOADING,
    FMOD_OPENSTATE_ERROR,
    FMOD_OPENSTATE_CONNECTING,
    FMOD_OPENSTATE_BUFFERING,
    FMOD_OPENSTATE_SEEKING,
    FMOD_OPENSTATE_STREAMING,
    FMOD_OPENSTATE_SETPOSITION,
    FMOD_OPENSTATE_MAX,
    FMOD_OPENSTATE_FORCEINT = 65536,
}

typedef int FMOD_SOUNDGROUP_BEHAVIOR;
enum : FMOD_SOUNDGROUP_BEHAVIOR
{
    FMOD_SOUNDGROUP_BEHAVIOR_FAIL,
    FMOD_SOUNDGROUP_BEHAVIOR_MUTE,
    FMOD_SOUNDGROUP_BEHAVIOR_STEALLOWEST,

    FMOD_SOUNDGROUP_BEHAVIOR_MAX,
    FMOD_SOUNDGROUP_BEHAVIOR_FORCEINT = 65536
}

typedef int FMOD_CHANNEL_CALLBACKTYPE;
enum : FMOD_CHANNEL_CALLBACKTYPE
{
    FMOD_CHANNEL_CALLBACKTYPE_END,
    FMOD_CHANNEL_CALLBACKTYPE_VIRTUALVOICE,
    FMOD_CHANNEL_CALLBACKTYPE_SYNCPOINT,
    FMOD_CHANNEL_CALLBACKTYPE_OCCLUSION,
    FMOD_CHANNEL_CALLBACKTYPE_MAX,
    FMOD_CHANNEL_CALLBACKTYPE_FORCEINT = 65536,
}

typedef int FMOD_SYSTEM_CALLBACKTYPE;
enum : FMOD_SYSTEM_CALLBACKTYPE
{
    FMOD_SYSTEM_CALLBACKTYPE_DEVICELISTCHANGED,         /* Called from System::update when the enumerated list of devices has changed. */
    FMOD_SYSTEM_CALLBACKTYPE_MEMORYALLOCATIONFAILED,    /* Called directly when a memory allocation fails somewhere in FMOD. */
    FMOD_SYSTEM_CALLBACKTYPE_THREADCREATED,             /* Called directly when a thread is created. */
    FMOD_SYSTEM_CALLBACKTYPE_BADDSPCONNECTION,          /* Called when a bad connection was made with DSP::addInput. Usually called from mixer thread because that is where the connections are made.  */
    FMOD_SYSTEM_CALLBACKTYPE_BADDSPLEVEL,               /* Called when too many effects were added exceeding the maximum tree depth of 128.  This is most likely caused by accidentally adding too many DSP effects. Usually called from mixer thread because that is where the connections are made.  */

    FMOD_SYSTEM_CALLBACKTYPE_MAX,                       /* Maximum number of callback types supported. */
    FMOD_SYSTEM_CALLBACKTYPE_FORCEINT = 65536           /* Makes sure this enum is signed 32bit. */
}
/*
    FMOD Callbacks
*/

extern(System) {

alias FMOD_RESULT function(FMOD_SYSTEM *system, FMOD_SYSTEM_CALLBACKTYPE type, void *commanddata1, void *commanddata2) FMOD_SYSTEM_CALLBACK;

alias FMOD_RESULT function(FMOD_CHANNEL *channel, FMOD_CHANNEL_CALLBACKTYPE type, void *commanddata1, void *commanddata2) FMOD_CHANNEL_CALLBACK;

alias FMOD_RESULT function(FMOD_SOUND *sound, FMOD_RESULT result) FMOD_SOUND_NONBLOCKCALLBACK;
alias FMOD_RESULT function(FMOD_SOUND *sound, void *data, uint datalen) FMOD_SOUND_PCMREADCALLBACK;
alias FMOD_RESULT function(FMOD_SOUND *sound, int subsound, uint position, FMOD_TIMEUNIT postype) FMOD_SOUND_PCMSETPOSCALLBACK;

alias FMOD_RESULT function(char *name, int unicode, uint *filesize, void **handle, void **userdata) FMOD_FILE_OPENCALLBACK;
alias FMOD_RESULT function(void *handle, void *userdata) FMOD_FILE_CLOSECALLBACK;
alias FMOD_RESULT function(void *handle, void *buffer, uint sizebytes, uint *bytesread, void *userdata) FMOD_FILE_READCALLBACK;
alias FMOD_RESULT function(void *handle, uint pos, void *userdata) FMOD_FILE_SEEKCALLBACK;

alias void* function(uint size, FMOD_MEMORY_TYPE type) FMOD_MEMORY_ALLOCCALLBACK;
alias void* function(void *ptr, uint size, FMOD_MEMORY_TYPE type) FMOD_MEMORY_REALLOCCALLBACK;
alias void  function(void *ptr, FMOD_MEMORY_TYPE type) FMOD_MEMORY_FREECALLBACK;

alias float function(FMOD_CHANNEL *channel, float distance) FMOD_3D_ROLLOFFCALLBACK;

}

typedef int FMOD_DSP_FFT_WINDOW;
enum : FMOD_DSP_FFT_WINDOW
{
    FMOD_DSP_FFT_WINDOW_RECT,
    FMOD_DSP_FFT_WINDOW_TRIANGLE,
    FMOD_DSP_FFT_WINDOW_HAMMING,
    FMOD_DSP_FFT_WINDOW_HANNING,
    FMOD_DSP_FFT_WINDOW_BLACKMAN,
    FMOD_DSP_FFT_WINDOW_BLACKMANHARRIS,
    FMOD_DSP_FFT_WINDOW_MAX,
    FMOD_DSP_FFT_WINDOW_FORCEINT = 65536,
}


typedef int FMOD_DSP_RESAMPLER;
enum : FMOD_DSP_RESAMPLER
{
    FMOD_DSP_RESAMPLER_NOINTERP,
    FMOD_DSP_RESAMPLER_LINEAR,
    FMOD_DSP_RESAMPLER_CUBIC,
    FMOD_DSP_RESAMPLER_SPLINE,
    FMOD_DSP_RESAMPLER_MAX,
    FMOD_DSP_RESAMPLER_FORCEINT = 65536,
}


typedef int FMOD_TAGTYPE;
enum : FMOD_TAGTYPE
{
    FMOD_TAGTYPE_UNKNOWN,
    FMOD_TAGTYPE_ID3V1,
    FMOD_TAGTYPE_ID3V2,
    FMOD_TAGTYPE_VORBISCOMMENT,
    FMOD_TAGTYPE_SHOUTCAST,
    FMOD_TAGTYPE_ICECAST,
    FMOD_TAGTYPE_ASF,
    FMOD_TAGTYPE_MIDI,
    FMOD_TAGTYPE_PLAYLIST,
    FMOD_TAGTYPE_FMOD,
    FMOD_TAGTYPE_USER,
    FMOD_TAGTYPE_MAX,
    FMOD_TAGTYPE_FORCEINT = 65536,
}


typedef int FMOD_TAGDATATYPE;
enum : FMOD_TAGDATATYPE
{
    FMOD_TAGDATATYPE_BINARY,
    FMOD_TAGDATATYPE_INT,
    FMOD_TAGDATATYPE_FLOAT,
    FMOD_TAGDATATYPE_STRING,
    FMOD_TAGDATATYPE_STRING_UTF16,
    FMOD_TAGDATATYPE_STRING_UTF16BE,
    FMOD_TAGDATATYPE_STRING_UTF8,
    FMOD_TAGDATATYPE_CDTOC,
    FMOD_TAGDATATYPE_MAX,
    FMOD_TAGDATATYPE_FORCEINT = 65536,
}

typedef int FMOD_DELAYTYPE;
enum : FMOD_DELAYTYPE
{
    FMOD_DELAYTYPE_END_MS,
    FMOD_DELAYTYPE_DSPCLOCK_START,
    FMOD_DELAYTYPE_DSPCLOCK_END,
    FMOD_DELAYTYPE_DSPCLOCK_PAUSE,

    FMOD_DELAYTYPE_MAX,
    FMOD_DELAYTYPE_FORCEINT = 65536
}


struct FMOD_TAG
{
    FMOD_TAGTYPE type;
    FMOD_TAGDATATYPE datatype;
    char *name;
    void *data;
    uint datalen;
    FMOD_BOOL updated;
}


struct FMOD_CDTOC
{
    int numtracks;
    int [100]min;
    int [100]sec;
    int [100]frame;
}


enum {
	FMOD_TIMEUNIT_MS = 0x00000001,
	FMOD_TIMEUNIT_PCM = 0x00000002,
	FMOD_TIMEUNIT_PCMBYTES = 0x00000004,
	FMOD_TIMEUNIT_RAWBYTES = 0x00000008,
	FMOD_TIMEUNIT_MODORDER = 0x00000100,
	FMOD_TIMEUNIT_MODROW = 0x00000200,
	FMOD_TIMEUNIT_MODPATTERN = 0x00000400,
	FMOD_TIMEUNIT_SENTENCE_MS = 0x00010000,
	FMOD_TIMEUNIT_SENTENCE_PCM = 0x00020000,
	FMOD_TIMEUNIT_SENTENCE_PCMBYTES = 0x00040000,
	FMOD_TIMEUNIT_SENTENCE = 0x00080000,
	FMOD_TIMEUNIT_SENTENCE_SUBSOUND = 0x00100000,
	FMOD_TIMEUNIT_BUFFERED = 0x10000000,
}

typedef int FMOD_SPEAKERMAPTYPE;
enum : FMOD_SPEAKERMAPTYPE
{
    FMOD_SPEAKERMAPTYPE_DEFAULT,
    FMOD_SPEAKERMAPTYPE_ALLMONO,
    FMOD_SPEAKERMAPTYPE_ALLSTEREO,
    FMOD_SPEAKERMAPTYPE_51_PROTOOLS,
}


struct FMOD_CREATESOUNDEXINFO
{
    int cbsize;
    uint length;
    uint fileoffset;
    int numchannels;
    int defaultfrequency;
    FMOD_SOUND_FORMAT format;
    uint decodebuffersize;
    int initialsubsound;
    int numsubsounds;
    int *inclusionlist;
    int inclusionlistnum;
    FMOD_SOUND_PCMREADCALLBACK pcmreadcallback;
    FMOD_SOUND_PCMSETPOSCALLBACK pcmsetposcallback;
    FMOD_SOUND_NONBLOCKCALLBACK nonblockcallback;
    char *dlsname;
    char *encryptionkey;
    int maxpolyphony;
    void *userdata;
    FMOD_SOUND_TYPE suggestedsoundtype;
    FMOD_FILE_OPENCALLBACK useropen;
    FMOD_FILE_CLOSECALLBACK userclose;
    FMOD_FILE_READCALLBACK userread;
    FMOD_FILE_SEEKCALLBACK userseek;
    FMOD_SPEAKERMAPTYPE speakermap;
    FMOD_SOUNDGROUP *initialsoundgroup;
    uint initialseekposition;
    FMOD_TIMEUNIT initialseekpostype;
    int ignoresetfilesystem;
}


struct FMOD_REVERB_PROPERTIES
{
    int Instance;
    int Environment;
    float EnvSize;
    float EnvDiffusion;
    int Room;
    int RoomHF;
    int RoomLF;
    float DecayTime;
    float DecayHFRatio;
    float DecayLFRatio;
    int Reflections;
    float ReflectionsDelay;
    float [3]ReflectionsPan;
    int Reverb;
    float ReverbDelay;
    float [3]ReverbPan;
    float EchoTime;
    float EchoDepth;
    float ModulationTime;
    float ModulationDepth;
    float AirAbsorptionHF;
    float HFReference;
    float LFReference;
    float RoomRolloffFactor;
    float Diffusion;
    float Density;
    uint Flags;
}


enum {
	FMOD_REVERB_FLAGS_DECAYTIMESCALE = 0x00000001,
	FMOD_REVERB_FLAGS_REFLECTIONSSCALE = 0x00000002,
	FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE = 0x00000004,
	FMOD_REVERB_FLAGS_REVERBSCALE = 0x00000008,
	FMOD_REVERB_FLAGS_REVERBDELAYSCALE = 0x00000010,
	FMOD_REVERB_FLAGS_DECAYHFLIMIT = 0x00000020,
	FMOD_REVERB_FLAGS_ECHOTIMESCALE = 0x00000040,
	FMOD_REVERB_FLAGS_MODULATIONTIMESCALE = 0x00000080,
	FMOD_REVERB_FLAGS_CORE0 = 0x00000100,
	FMOD_REVERB_FLAGS_CORE1 = 0x00000200,
	FMOD_REVERB_FLAGS_HIGHQUALITYREVERB = 0x00000400,
	FMOD_REVERB_FLAGS_HIGHQUALITYDPL2REVERB = 0x00000800,

	FMOD_REVERB_FLAGS_DEFAULT =  (FMOD_REVERB_FLAGS_DECAYTIMESCALE |
                                    FMOD_REVERB_FLAGS_REFLECTIONSSCALE |
                                    FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE |
                                    FMOD_REVERB_FLAGS_REVERBSCALE |
                                    FMOD_REVERB_FLAGS_REVERBDELAYSCALE |
                                    FMOD_REVERB_FLAGS_DECAYHFLIMIT |
                                    FMOD_REVERB_FLAGS_CORE0 |
                                    FMOD_REVERB_FLAGS_CORE1),
}


/*                                                           Inst Env  Size    Diffus  Room   RoomHF  RmLF DecTm   DecHF  DecLF   Refl  RefDel  RefPan               Revb  RevDel  ReverbPan           EchoTm  EchDp  ModTm  ModDp  AirAbs  HFRef    LFRef  RRlOff Diffus  Densty  FLAGS */
const FMOD_REVERB_PROPERTIES FMOD_PRESET_OFF              = {  0, -1,  7.5f,   1.00f, -10000, -10000, 0,   1.00f,  1.00f, 1.0f,  -2602, 0.007f, [ 0.0f,0.0f,0.0f ],   200, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,   0.0f,   0.0f, 0x33f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_GENERIC          = {  0,  0,  7.5f,   1.00f, -1000,  -100,   0,   1.49f,  0.83f, 1.0f,  -2602, 0.007f, [ 0.0f,0.0f,0.0f ],   200, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PADDEDCELL       = {  0,  1,  1.4f,   1.00f, -1000,  -6000,  0,   0.17f,  0.10f, 1.0f,  -1204, 0.001f, [ 0.0f,0.0f,0.0f ],   207, 0.002f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_ROOM             = {  0,  2,  1.9f,   1.00f, -1000,  -454,   0,   0.40f,  0.83f, 1.0f,  -1646, 0.002f, [ 0.0f,0.0f,0.0f ],    53, 0.003f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_BATHROOM         = {  0,  3,  1.4f,   1.00f, -1000,  -1200,  0,   1.49f,  0.54f, 1.0f,   -370, 0.007f, [ 0.0f,0.0f,0.0f ],  1030, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f,  60.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_LIVINGROOM       = {  0,  4,  2.5f,   1.00f, -1000,  -6000,  0,   0.50f,  0.10f, 1.0f,  -1376, 0.003f, [ 0.0f,0.0f,0.0f ], -1104, 0.004f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_STONEROOM        = {  0,  5,  11.6f,  1.00f, -1000,  -300,   0,   2.31f,  0.64f, 1.0f,   -711, 0.012f, [ 0.0f,0.0f,0.0f ],    83, 0.017f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_AUDITORIUM       = {  0,  6,  21.6f,  1.00f, -1000,  -476,   0,   4.32f,  0.59f, 1.0f,   -789, 0.020f, [ 0.0f,0.0f,0.0f ],  -289, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_CONCERTHALL      = {  0,  7,  19.6f,  1.00f, -1000,  -500,   0,   3.92f,  0.70f, 1.0f,  -1230, 0.020f, [ 0.0f,0.0f,0.0f ],    -2, 0.029f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_CAVE             = {  0,  8,  14.6f,  1.00f, -1000,  0,      0,   2.91f,  1.30f, 1.0f,   -602, 0.015f, [ 0.0f,0.0f,0.0f ],  -302, 0.022f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_ARENA            = {  0,  9,  36.2f,  1.00f, -1000,  -698,   0,   7.24f,  0.33f, 1.0f,  -1166, 0.020f, [ 0.0f,0.0f,0.0f ],    16, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_HANGAR           = {  0,  10, 50.3f,  1.00f, -1000,  -1000,  0,   10.05f, 0.23f, 1.0f,   -602, 0.020f, [ 0.0f,0.0f,0.0f ],   198, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_CARPETTEDHALLWAY = {  0,  11, 1.9f,   1.00f, -1000,  -4000,  0,   0.30f,  0.10f, 1.0f,  -1831, 0.002f, [ 0.0f,0.0f,0.0f ], -1630, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_HALLWAY          = {  0,  12, 1.8f,   1.00f, -1000,  -300,   0,   1.49f,  0.59f, 1.0f,  -1219, 0.007f, [ 0.0f,0.0f,0.0f ],   441, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_STONECORRIDOR    = {  0,  13, 13.5f,  1.00f, -1000,  -237,   0,   2.70f,  0.79f, 1.0f,  -1214, 0.013f, [ 0.0f,0.0f,0.0f ],   395, 0.020f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_ALLEY            = {  0,  14, 7.5f,   0.30f, -1000,  -270,   0,   1.49f,  0.86f, 1.0f,  -1204, 0.007f, [ 0.0f,0.0f,0.0f ],    -4, 0.011f, [ 0.0f,0.0f,0.0f ], 0.125f, 0.95f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_FOREST           = {  0,  15, 38.0f,  0.30f, -1000,  -3300,  0,   1.49f,  0.54f, 1.0f,  -2560, 0.162f, [ 0.0f,0.0f,0.0f ],  -229, 0.088f, [ 0.0f,0.0f,0.0f ], 0.125f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  79.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_CITY             = {  0,  16, 7.5f,   0.50f, -1000,  -800,   0,   1.49f,  0.67f, 1.0f,  -2273, 0.007f, [ 0.0f,0.0f,0.0f ], -1691, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  50.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_MOUNTAINS        = {  0,  17, 100.0f, 0.27f, -1000,  -2500,  0,   1.49f,  0.21f, 1.0f,  -2780, 0.300f, [ 0.0f,0.0f,0.0f ], -1434, 0.100f, [ 0.0f,0.0f,0.0f ], 0.250f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  27.0f, 100.0f, 0x1f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_QUARRY           = {  0,  18, 17.5f,  1.00f, -1000,  -1000,  0,   1.49f,  0.83f, 1.0f, -10000, 0.061f, [ 0.0f,0.0f,0.0f ],   500, 0.025f, [ 0.0f,0.0f,0.0f ], 0.125f, 0.70f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PLAIN            = {  0,  19, 42.5f,  0.21f, -1000,  -2000,  0,   1.49f,  0.50f, 1.0f,  -2466, 0.179f, [ 0.0f,0.0f,0.0f ], -1926, 0.100f, [ 0.0f,0.0f,0.0f ], 0.250f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  21.0f, 100.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PARKINGLOT       = {  0,  20, 8.3f,   1.00f, -1000,  0,      0,   1.65f,  1.50f, 1.0f,  -1363, 0.008f, [ 0.0f,0.0f,0.0f ], -1153, 0.012f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_SEWERPIPE        = {  0,  21, 1.7f,   0.80f, -1000,  -1000,  0,   2.81f,  0.14f, 1.0f,    429, 0.014f, [ 0.0f,0.0f,0.0f ],  1023, 0.021f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  80.0f,  60.0f, 0x3f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_UNDERWATER       = {  0,  22, 1.8f,   1.00f, -1000,  -4000,  0,   1.49f,  0.10f, 1.0f,   -449, 0.007f, [ 0.0f,0.0f,0.0f ],  1700, 0.011f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 1.18f, 0.348f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f };

/* Non I3DL2 presets */

const FMOD_REVERB_PROPERTIES FMOD_PRESET_DRUGGED          = {  0,  23, 1.9f,   0.50f, -1000,  0,      0,   8.39f,  1.39f, 1.0f,  -115,  0.002f, [ 0.0f,0.0f,0.0f ],   985, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.25f, 1.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_DIZZY            = {  0,  24, 1.8f,   0.60f, -1000,  -400,   0,   17.23f, 0.56f, 1.0f,  -1713, 0.020f, [ 0.0f,0.0f,0.0f ],  -613, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 1.00f, 0.81f, 0.310f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PSYCHOTIC        = {  0,  25, 1.0f,   0.50f, -1000,  -151,   0,   7.56f,  0.91f, 1.0f,  -626,  0.020f, [ 0.0f,0.0f,0.0f ],   774, 0.030f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 4.00f, 1.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f };

/* PlayStation 2 / PlayStation Portable Only presets */

const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_ROOM         = {  0,  1,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_STUDIO_A     = {  0,  2,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_STUDIO_B     = {  0,  3,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_STUDIO_C     = {  0,  4,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_HALL         = {  0,  5,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_SPACE        = {  0,  6,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_ECHO         = {  0,  7,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.75f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_DELAY        = {  0,  8,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };
const FMOD_REVERB_PROPERTIES FMOD_PRESET_PS2_PIPE         = {  0,  9,  0,      0,     0,      0,      0,   0.0f,   0.0f,  0.0f,     0,  0.000f, [ 0.0f,0.0f,0.0f ],     0, 0.000f, [ 0.0f,0.0f,0.0f ], 0.250f, 0.00f, 0.00f, 0.000f,  0.0f, 0000.0f,   0.0f, 0.0f,   0.0f,   0.0f, 0x31f };


struct FMOD_REVERB_CHANNELPROPERTIES
{
    int Direct;
    int DirectHF;
    int Room;
    int RoomHF;
    int Obstruction;
    float ObstructionLFRatio;
    int Occlusion;
    float OcclusionLFRatio;
    float OcclusionRoomRatio;
    float OcclusionDirectRatio;
    int Exclusion;
    float ExclusionLFRatio;
    int OutsideVolumeHF;
    float DopplerFactor;
    float RolloffFactor;
    float RoomRolloffFactor;
    float AirAbsorptionFactor;
    uint Flags;
    FMOD_DSP *ConnectionPoint;
}


enum {
    FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO = 0x00000001,
    FMOD_REVERB_CHANNELFLAGS_ROOMAUTO = 0x00000002,
    FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO = 0x00000004,
    FMOD_REVERB_CHANNELFLAGS_INSTANCE0 = 0x00000010,
    FMOD_REVERB_CHANNELFLAGS_INSTANCE1 = 0x00000020,
    FMOD_REVERB_CHANNELFLAGS_INSTANCE2 = 0x00000040,
    FMOD_REVERB_CHANNELFLAGS_INSTANCE3 = 0x00000080,

	FMOD_REVERB_CHANNELFLAGS_DEFAULT =  (FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO |
                                           FMOD_REVERB_CHANNELFLAGS_ROOMAUTO |
                                           FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO |
                                           FMOD_REVERB_CHANNELFLAGS_INSTANCE0),
}


struct FMOD_ADVANCEDSETTINGS
{
    int cbsize;
    int maxMPEGcodecs;
    int maxADPCMcodecs;
    int maxXMAcodecs;
    int maxCELTcodecs;
    int maxPCMcodecs;
    int ASIONumChannels;
    char **ASIOChannelList;
    FMOD_SPEAKER *ASIOSpeakerList;
    int max3DReverbDSPs;
    float HRTFMinAngle;
    float HRTFMaxAngle;
    float HRTFFreq;
    float vol0virtualvol;
    int eventqueuesize;
    uint defaultDecodeBufferSize;
    char *debugLogFilename;
    ushort profileport;
    uint geometryMaxFadeTime;
    uint maxSpectrumWaveDataBuffers;
}


typedef int FMOD_CHANNELINDEX;
enum : FMOD_CHANNELINDEX
{
    FMOD_CHANNEL_FREE = -1,
    FMOD_CHANNEL_REUSE = -2,
}


/*
enum
{
    FMOD_LISTENERREVERB_STATIC,
    FMOD_LISTENERREVERB_DYNAMIC3D,
}
alias int FMOD_LISTENERREVERB_MODE;


enum
{
    FMOD_REVERB_PHYSICAL = 1,
    FMOD_REVERB_VIRTUAL,
}
alias int FMOD_REVERB_MODE;
*/
