///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:24 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\vectors.c /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\vectors. /
//                    c" -D IAR -D TWR_K60N512 -lCN "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM_128KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\tsi\RAM_128KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM_128KB /
//                    \Obj\" --no_cse --no_unroll --no_inline                 /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    "D:\Program Files\IAR Systems\Embedded Workbench 6.0    /
//                    Evaluation\arm\INC\c\DLib_Config_Normal.h" -I "F:\My    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\projects\tsi\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\common\" -I "F:\My Works\K60\Kinetis512\kinetis-sc\ /
//                    build\iar\tsi\..\..\..\src\cpu\" -I "F:\My              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\cpu\headers\" -I "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\uart\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\mcg\" -I "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\wdog\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\platforms\" -I "F:\My Works\K60\Kinetis512\kinetis- /
//                    sc\build\iar\tsi\..\" -Ol --use_c++_inline              /
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM /
//                    _128KB\List\vectors.s                                   /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME vectors

        EXTERN TSI_isr
        EXTERN __BOOT_STACK_ADDRESS
        EXTERN __startup
        EXTERN printf

        PUBLIC __vector_table
        PUBLIC default_isr

// F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\vectors.c
//    1 /******************************************************************************
//    2 * File:    vectors.c
//    3 *
//    4 * Purpose: Configure interrupt vector table for Kinetis.
//    5 ******************************************************************************/
//    6 
//    7 #include "vectors.h"
//    8 #include "isr.h"
//    9 #include "common.h"
//   10 
//   11 /******************************************************************************
//   12 * Vector Table
//   13 ******************************************************************************/
//   14 typedef void (*vector_entry)(void);
//   15 
//   16 #if defined(IAR)
//   17 	#pragma location = ".intvec"

        SECTION `.intvec`:CONST:REORDER:NOROOT(2)
//   18 	const vector_entry  __vector_table[] = //@ ".intvec" =
__vector_table:
        DATA
        DC32 __BOOT_STACK_ADDRESS, __startup, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 TSI_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, default_isr, default_isr, default_isr
        DC32 default_isr, default_isr, 0FFFFFFFFH, 0FFFFFFFFH, 0FFFFFFFFH
        DC32 0FFFFFFFEH
//   19 #elif defined(CW)
//   20 	#pragma define_section vectortable ".vectortable" ".vectortable" ".vectortable" far_abs R
//   21 	#define VECTOR __declspec(vectortable)
//   22 	const VECTOR vector_entry  __vector_table[] = //@ ".intvec" =
//   23 #endif
//   24 
//   25 {
//   26    VECTOR_000,           /* Initial SP           */
//   27    VECTOR_001,           /* Initial PC           */
//   28    VECTOR_002,
//   29    VECTOR_003,
//   30    VECTOR_004,
//   31    VECTOR_005,
//   32    VECTOR_006,
//   33    VECTOR_007,
//   34    VECTOR_008,
//   35    VECTOR_009,
//   36    VECTOR_010,
//   37    VECTOR_011,
//   38    VECTOR_012,
//   39    VECTOR_013,
//   40    VECTOR_014,
//   41    VECTOR_015,
//   42    VECTOR_016,
//   43    VECTOR_017,
//   44    VECTOR_018,
//   45    VECTOR_019,
//   46    VECTOR_020,
//   47    VECTOR_021,
//   48    VECTOR_022,
//   49    VECTOR_023,
//   50    VECTOR_024,
//   51    VECTOR_025,
//   52    VECTOR_026,
//   53    VECTOR_027,
//   54    VECTOR_028,
//   55    VECTOR_029,
//   56    VECTOR_030,
//   57    VECTOR_031,
//   58    VECTOR_032,
//   59    VECTOR_033,
//   60    VECTOR_034,
//   61    VECTOR_035,
//   62    VECTOR_036,
//   63    VECTOR_037,
//   64    VECTOR_038,
//   65    VECTOR_039,
//   66    VECTOR_040,
//   67    VECTOR_041,
//   68    VECTOR_042,
//   69    VECTOR_043,
//   70    VECTOR_044,
//   71    VECTOR_045,
//   72    VECTOR_046,
//   73    VECTOR_047,
//   74    VECTOR_048,
//   75    VECTOR_049,
//   76    VECTOR_050,
//   77    VECTOR_051,
//   78    VECTOR_052,
//   79    VECTOR_053,
//   80    VECTOR_054,
//   81    VECTOR_055,
//   82    VECTOR_056,
//   83    VECTOR_057,
//   84    VECTOR_058,
//   85    VECTOR_059,
//   86    VECTOR_060,
//   87    VECTOR_061,
//   88    VECTOR_062,
//   89    VECTOR_063,
//   90    VECTOR_064,
//   91    VECTOR_065,
//   92    VECTOR_066,
//   93    VECTOR_067,
//   94    VECTOR_068,
//   95    VECTOR_069,
//   96    VECTOR_070,
//   97    VECTOR_071,
//   98    VECTOR_072,
//   99    VECTOR_073,
//  100    VECTOR_074,
//  101    VECTOR_075,
//  102    VECTOR_076,
//  103    VECTOR_077,
//  104    VECTOR_078,
//  105    VECTOR_079,
//  106    VECTOR_080,
//  107    VECTOR_081,
//  108    VECTOR_082,
//  109    VECTOR_083,
//  110    VECTOR_084,
//  111    VECTOR_085,
//  112    VECTOR_086,
//  113    VECTOR_087,
//  114    VECTOR_088,
//  115    VECTOR_089,
//  116    VECTOR_090,
//  117    VECTOR_091,
//  118    VECTOR_092,
//  119    VECTOR_093,
//  120    VECTOR_094,
//  121    VECTOR_095,
//  122    VECTOR_096,
//  123    VECTOR_097,
//  124    VECTOR_098,
//  125    VECTOR_099,
//  126    VECTOR_100,
//  127    VECTOR_101,
//  128    VECTOR_102,
//  129    VECTOR_103,
//  130    VECTOR_104,
//  131    VECTOR_105,
//  132    VECTOR_106,
//  133    VECTOR_107,
//  134    VECTOR_108,
//  135    VECTOR_109,
//  136    VECTOR_110,
//  137    VECTOR_111,
//  138    VECTOR_112,
//  139    VECTOR_113,
//  140    VECTOR_114,
//  141    VECTOR_115,
//  142    VECTOR_116,
//  143    VECTOR_117,
//  144    VECTOR_118,
//  145    VECTOR_119,
//  146    VECTOR_120,
//  147    VECTOR_121,
//  148    VECTOR_122,
//  149    VECTOR_123,
//  150    VECTOR_124,
//  151    VECTOR_125,
//  152    VECTOR_126,
//  153    VECTOR_127,
//  154    VECTOR_128,
//  155    VECTOR_129,
//  156    VECTOR_130,
//  157    VECTOR_131,
//  158    VECTOR_132,
//  159    VECTOR_133,
//  160    VECTOR_134,
//  161    VECTOR_135,
//  162    VECTOR_136,
//  163    VECTOR_137,
//  164    VECTOR_138,
//  165    VECTOR_139,
//  166    VECTOR_140,
//  167    VECTOR_141,
//  168    VECTOR_142,
//  169    VECTOR_143,
//  170    VECTOR_144,
//  171    VECTOR_145,
//  172    VECTOR_146,
//  173    VECTOR_147,
//  174    VECTOR_148,
//  175    VECTOR_149,
//  176    VECTOR_150,
//  177    VECTOR_151,
//  178    VECTOR_152,
//  179    VECTOR_153,
//  180    VECTOR_154,
//  181    VECTOR_155,
//  182    VECTOR_156,
//  183    VECTOR_157,
//  184    VECTOR_158,
//  185    VECTOR_159,
//  186    VECTOR_160,
//  187    VECTOR_161,
//  188    VECTOR_162,
//  189    VECTOR_163,
//  190    VECTOR_164,
//  191    VECTOR_165,
//  192    VECTOR_166,
//  193    VECTOR_167,
//  194    VECTOR_168,
//  195    VECTOR_169,
//  196    VECTOR_170,
//  197    VECTOR_171,
//  198    VECTOR_172,
//  199    VECTOR_173,
//  200    VECTOR_174,
//  201    VECTOR_175,
//  202    VECTOR_176,
//  203    VECTOR_177,
//  204    VECTOR_178,
//  205    VECTOR_179,
//  206    VECTOR_180,
//  207    VECTOR_181,
//  208    VECTOR_182,
//  209    VECTOR_183,
//  210    VECTOR_184,
//  211    VECTOR_185,
//  212    VECTOR_186,
//  213    VECTOR_187,
//  214    VECTOR_188,
//  215    VECTOR_189,
//  216    VECTOR_190,
//  217    VECTOR_191,
//  218    VECTOR_192,
//  219    VECTOR_193,
//  220    VECTOR_194,
//  221    VECTOR_195,
//  222    VECTOR_196,
//  223    VECTOR_197,
//  224    VECTOR_198,
//  225    VECTOR_199,
//  226    VECTOR_200,
//  227    VECTOR_201,
//  228    VECTOR_202,
//  229    VECTOR_203,
//  230    VECTOR_204,
//  231    VECTOR_205,
//  232    VECTOR_206,
//  233    VECTOR_207,
//  234    VECTOR_208,
//  235    VECTOR_209,
//  236    VECTOR_210,
//  237    VECTOR_211,
//  238    VECTOR_212,
//  239    VECTOR_213,
//  240    VECTOR_214,
//  241    VECTOR_215,
//  242    VECTOR_216,
//  243    VECTOR_217,
//  244    VECTOR_218,
//  245    VECTOR_219,
//  246    VECTOR_220,
//  247    VECTOR_221,
//  248    VECTOR_222,
//  249    VECTOR_223,
//  250    VECTOR_224,
//  251    VECTOR_225,
//  252    VECTOR_226,
//  253    VECTOR_227,
//  254    VECTOR_228,
//  255    VECTOR_229,
//  256    VECTOR_230,
//  257    VECTOR_231,
//  258    VECTOR_232,
//  259    VECTOR_233,
//  260    VECTOR_234,
//  261    VECTOR_235,
//  262    VECTOR_236,
//  263    VECTOR_237,
//  264    VECTOR_238,
//  265    VECTOR_239,
//  266    VECTOR_240,
//  267    VECTOR_241,
//  268    VECTOR_242,
//  269    VECTOR_243,
//  270    VECTOR_244,
//  271    VECTOR_245,
//  272    VECTOR_246,
//  273    VECTOR_247,
//  274    VECTOR_248,
//  275    VECTOR_249,
//  276    VECTOR_250,
//  277    VECTOR_251,
//  278    VECTOR_252,
//  279    VECTOR_253,
//  280    VECTOR_254,
//  281    VECTOR_255,
//  282    CONFIG_1,
//  283    CONFIG_2,
//  284    CONFIG_3,
//  285    CONFIG_4,
//  286 
//  287 };
//  288 // VECTOR_TABLE end
//  289 /******************************************************************************
//  290 * default_isr(void)
//  291 *
//  292 * Default ISR definition.
//  293 *
//  294 * In:  n/a
//  295 * Out: n/a
//  296 ******************************************************************************/
//  297 //#if (defined(CW))
//  298 //__declspec(interrupt)
//  299 //#endif
//  300 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  301 void default_isr(void)
//  302 {
default_isr:
        PUSH     {R7,LR}
//  303    #define VECTORNUM                     (*(volatile uint8_t*)(0xE000ED04))
//  304 
//  305    printf("\n****default_isr entered on vector %d*****\r\n\n",VECTORNUM);
        LDR.N    R0,??DataTable1  ;; 0xe000ed04
        LDRB     R1,[R0, #+0]
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        ADR.W    R0,`?<Constant "\\n****default_isr ente...">`
        BL       printf
//  306    return;
        POP      {R0,PC}          ;; return
//  307 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable1:
        DC32     0xe000ed04

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\n****default_isr ente...">`:
        ; Initializer data, 48 bytes
        DC8 10, 42, 42, 42, 42, 100, 101, 102, 97, 117
        DC8 108, 116, 95, 105, 115, 114, 32, 101, 110, 116
        DC8 101, 114, 101, 100, 32, 111, 110, 32, 118, 101
        DC8 99, 116, 111, 114, 32, 37, 100, 42, 42, 42
        DC8 42, 42, 13, 10, 10, 0, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  308 /******************************************************************************/
//  309 /* End of "vectors.c" */
// 
// 1 040 bytes in section .intvec
//    70 bytes in section .text
// 
//    70 bytes of CODE  memory
// 1 040 bytes of CONST memory
//
//Errors: none
//Warnings: none
