///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      06/Mar/2012  12:19:31 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\common\uif.c  /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\common\uif.c /
//                    " -D IAR -D TWR_K60N512 -lCN "F:\My                     /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\gpio\RAM_64KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \Obj\" --no_cse --no_unroll --no_inline                 /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    "D:\Program Files\IAR Systems\Embedded Workbench 6.0    /
//                    Evaluation\arm\INC\c\DLib_Config_Normal.h" -I "F:\My    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\projects\gpio\" -I "F:\My                          /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\common\" -I "F:\My Works\K60\Kinetis512\kinetis-sc /
//                    \build\iar\gpio\..\..\..\src\cpu\" -I "F:\My            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\cpu\headers\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\uart\" -I "F:\My                           /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\mcg\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\wdog\" -I "F:\My                           /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\platforms\" -I "F:\My                              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\"     /
//                    -Ol --use_c++_inline                                    /
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RA /
//                    M_64KB\List\uif.s                                       /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME uif

        EXTERN UIF_CMDTAB
        EXTERN UIF_NUM_CMD
        EXTERN UIF_NUM_SETCMD
        EXTERN UIF_SETCMDTAB
        EXTERN in_char
        EXTERN out_char
        EXTERN printf
        EXTERN strcasecmp
        EXTERN strcpy
        EXTERN strtoul

        PUBLIC HELPMSG
        PUBLIC INVALUE
        PUBLIC INVARG
        PUBLIC get_line
        PUBLIC get_value
        PUBLIC make_argv
        PUBLIC run_cmd
        PUBLIC uif_cmd_help
        PUBLIC uif_cmd_set
        PUBLIC uif_cmd_show

// F:\My Works\K60\Kinetis512\kinetis-sc\src\common\uif.c
//    1 /*
//    2  * File:    uif.c
//    3  * Purpose: Provide an interactive user interface
//    4  *              
//    5  * Notes:   The commands, set/show parameters, and prompt are configured 
//    6  *          at the project level
//    7  */
//    8 
//    9 #include "common.h"
//   10 #include "uif.h"
//   11 
//   12 /********************************************************************/
//   13 /*
//   14  * Global messages -- constant strings
//   15  */
//   16 const char HELPMSG[] =
//   17     "Enter 'help' for help.\n";
//   18 
//   19 const char INVARG[] =
//   20     "Error: Invalid argument: %s\n";
//   21 
//   22 const char INVALUE[] = 
//   23     "Error: Invalid value: %s\n";
//   24 
//   25 /*
//   26  * Strings used by this file only
//   27  */
//   28 static const char INVCMD[] =
//   29     "Error: No such command: %s\n";
//   30 
//   31 static const char HELPFORMAT[] = 
//   32     "%8s  %-25s %s %s\n";
//   33 
//   34 static const char SYNTAX[] = 
//   35     "Error: Invalid syntax for: %s\n";
//   36 
//   37 static const char INVOPT[] = 
//   38     "Error:  Invalid set/show option: %s\n";
//   39 
//   40 static const char OPTFMT[] = 
//   41     "%12s: ";
//   42 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   43 static char cmdline1 [UIF_MAX_LINE];
cmdline1:
        DS8 80

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   44 static char cmdline2 [UIF_MAX_LINE];
cmdline2:
        DS8 80
//   45 
//   46 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   47 char *
//   48 get_line (char *line)
//   49 {
get_line:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//   50     int pos;
//   51     int ch;
//   52 
//   53     pos = 0;
        MOVS     R5,#+0
//   54     ch = (int)in_char();
        BL       in_char
        B.N      ??get_line_0
//   55     while ( (ch != 0x0D /* CR */) &&
//   56             (ch != 0x0A /* LF/NL */) &&
//   57             (pos < UIF_MAX_LINE))
//   58     {
//   59         switch (ch)
//   60         {
//   61             case 0x08:      /* Backspace */
//   62             case 0x7F:      /* Delete */
//   63                 if (pos > 0)
//   64                 {
//   65                     pos -= 1;
//   66                     out_char(0x08);    /* backspace */
//   67                     out_char(' ');
//   68                     out_char(0x08);    /* backspace */
//   69                 }
//   70                 break;
//   71             default:
//   72                 if ((pos+1) < UIF_MAX_LINE)
??get_line_1:
        ADDS     R1,R5,#+1
        CMP      R1,#+80
        BGE.N    ??get_line_2
//   73                 {
//   74                     if ((ch > 0x1f) && (ch < 0x80))
        SUBS     R1,R0,#+32
        CMP      R1,#+96
        BCS.N    ??get_line_2
//   75                     {
//   76                         line[pos++] = (char)ch;
        STRB     R0,[R5, R4]
        ADDS     R5,R5,#+1
//   77                         out_char((char)ch);
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       out_char
//   78                     }
//   79                 }
//   80                 break;
//   81         }
//   82         ch = (int)in_char();
??get_line_2:
??get_line_3:
        BL       in_char
??get_line_0:
        CMP      R0,#+13
        BEQ.N    ??get_line_4
        CMP      R0,#+10
        BEQ.N    ??get_line_4
        CMP      R5,#+80
        BGE.N    ??get_line_4
        MOVS     R1,R0
        CMP      R1,#+8
        BEQ.N    ??get_line_5
        CMP      R1,#+127
        BNE.N    ??get_line_1
??get_line_5:
        CMP      R5,#+1
        BLT.N    ??get_line_6
        SUBS     R5,R5,#+1
        MOVS     R0,#+8
        BL       out_char
        MOVS     R0,#+32
        BL       out_char
        MOVS     R0,#+8
        BL       out_char
??get_line_6:
        B.N      ??get_line_3
//   83     }
//   84     line[pos] = '\0';
??get_line_4:
        MOVS     R0,#+0
        STRB     R0,[R5, R4]
//   85     out_char(0x0D);    /* CR */
        MOVS     R0,#+13
        BL       out_char
//   86     out_char(0x0A);    /* LF */
        MOVS     R0,#+10
        BL       out_char
//   87 
//   88     return line;
        MOVS     R0,R4
        POP      {R1,R4,R5,PC}    ;; return
//   89 }
//   90 
//   91 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   92 int
//   93 make_argv (char *cmdline, char *argv[])
//   94 {
make_argv:
        PUSH     {R4,R5}
//   95     int argc, i, in_text;
//   96 
//   97     /* 
//   98      * Break cmdline into strings and argv
//   99      * It is permissible for argv to be NULL, in which case
//  100      * the purpose of this routine becomes to count args
//  101      */
//  102     argc = 0;
        MOVS     R2,#+0
//  103     i = 0;
        MOVS     R3,#+0
//  104     in_text = FALSE;
        MOVS     R4,#+0
        B.N      ??make_argv_0
//  105     while (cmdline[i] != '\0')  /* getline() must place 0x00 on end */
//  106     {
//  107         if (((cmdline[i] == ' ')   ||
//  108              (cmdline[i] == '\t')) )
//  109         {
//  110             if (in_text)
??make_argv_1:
        CMP      R4,#+0
        BEQ.N    ??make_argv_2
//  111             {
//  112                 /* end of command line argument */
//  113                 cmdline[i] = '\0';
        MOVS     R4,#+0
        STRB     R4,[R3, R0]
//  114                 in_text = FALSE;
        MOVS     R4,#+0
//  115             }
//  116             else
//  117             {
//  118                 /* still looking for next argument */
//  119                 
//  120             }
//  121         }
//  122         else
//  123         {
//  124             /* got non-whitespace character */
//  125             if (in_text)
//  126             {
//  127             }
//  128             else
//  129             {
//  130                 /* start of an argument */
//  131                 in_text = TRUE;
//  132                 if (argc < UIF_MAX_ARGS)
//  133                 {
//  134                     if (argv != NULL)
//  135                         argv[argc] = &cmdline[i];
//  136                     argc++;
//  137                 }
//  138                 else
//  139                     /*return argc;*/
//  140                     break;
//  141             }
//  142 
//  143         }
//  144         i++;    /* proceed to next character */
??make_argv_2:
        ADDS     R3,R3,#+1
??make_argv_0:
        LDRB     R5,[R3, R0]
        CMP      R5,#+0
        BEQ.N    ??make_argv_3
        LDRB     R5,[R3, R0]
        CMP      R5,#+32
        BEQ.N    ??make_argv_1
        LDRB     R5,[R3, R0]
        CMP      R5,#+9
        BEQ.N    ??make_argv_1
        CMP      R4,#+0
        BNE.N    ??make_argv_2
        MOVS     R4,#+1
        CMP      R2,#+10
        BGE.N    ??make_argv_4
        CMP      R1,#+0
        BEQ.N    ??make_argv_5
        ADDS     R5,R3,R0
        STR      R5,[R1, R2, LSL #+2]
??make_argv_5:
        ADDS     R2,R2,#+1
        B.N      ??make_argv_2
//  145     }
//  146     if (argv != NULL)
??make_argv_4:
??make_argv_3:
        CMP      R1,#+0
        BEQ.N    ??make_argv_6
//  147         argv[argc] = NULL;
        MOVS     R0,#+0
        STR      R0,[R1, R2, LSL #+2]
//  148     return argc;
??make_argv_6:
        MOVS     R0,R2
        POP      {R4,R5}
        BX       LR               ;; return
//  149 }
//  150 
//  151 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  152 void
//  153 run_cmd (void)
//  154 {
run_cmd:
        PUSH     {R4,R5,LR}
        SUB      SP,SP,#+44
//  155     /*
//  156      * Global array of pointers to emulate C argc,argv interface
//  157      */
//  158     int argc;
//  159     char *argv[UIF_MAX_ARGS + 1];   /* one extra for null terminator */
//  160 
//  161     get_line(cmdline1);
        LDR.N    R0,??DataTable16_3
        BL       get_line
//  162 
//  163     if (!(argc = make_argv(cmdline1,argv)))
        ADD      R1,SP,#+0
        LDR.N    R0,??DataTable16_3
        BL       make_argv
        MOVS     R4,R0
        CMP      R4,#+0
        BNE.N    ??run_cmd_0
//  164     {
//  165         /* no command entered, just a blank line */
//  166         strcpy(cmdline1,cmdline2);
        LDR.N    R1,??DataTable16_4
        LDR.N    R0,??DataTable16_3
        BL       strcpy
//  167         argc = make_argv(cmdline1,argv);
        ADD      R1,SP,#+0
        LDR.N    R0,??DataTable16_3
        BL       make_argv
        MOVS     R4,R0
//  168     }
//  169     cmdline2[0] = '\0';
??run_cmd_0:
        LDR.N    R0,??DataTable16_4
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  170 
//  171     if (argc)
        CMP      R4,#+0
        BEQ.N    ??run_cmd_1
//  172     {
//  173         int i;
//  174         for (i = 0; i < UIF_NUM_CMD; i++)
        MOVS     R5,#+0
        B.N      ??run_cmd_2
??run_cmd_3:
        ADDS     R5,R5,#+1
??run_cmd_2:
        LDR.N    R0,??DataTable16_5
        LDR      R0,[R0, #+0]
        CMP      R5,R0
        BGE.N    ??run_cmd_4
//  175         {
//  176             if (strcasecmp(UIF_CMDTAB[i].cmd,argv[0]) == 0)
        LDR      R1,[SP, #+0]
        MOVS     R0,#+28
        LDR.N    R2,??DataTable16_6
        MLA      R0,R0,R5,R2
        LDR      R0,[R0, #+0]
        BL       strcasecmp
        CMP      R0,#+0
        BNE.N    ??run_cmd_3
//  177             {
//  178                 if (((argc-1) >= UIF_CMDTAB[i].min_args) &&
//  179                     ((argc-1) <= UIF_CMDTAB[i].max_args))
        SUBS     R0,R4,#+1
        MOVS     R1,#+28
        LDR.N    R2,??DataTable16_6
        MLA      R1,R1,R5,R2
        LDR      R1,[R1, #+4]
        CMP      R0,R1
        BLT.N    ??run_cmd_5
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R5,R1
        LDR      R0,[R0, #+8]
        SUBS     R1,R4,#+1
        CMP      R0,R1
        BLT.N    ??run_cmd_5
//  180                 {
//  181                     if (UIF_CMDTAB[i].flags & UIF_CMD_FLAG_REPEAT)
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R5,R1
        LDRB     R0,[R0, #+12]
        LSLS     R0,R0,#+31
        BPL.N    ??run_cmd_6
//  182                     {
//  183                         strcpy(cmdline2,argv[0]);
        LDR      R1,[SP, #+0]
        LDR.N    R0,??DataTable16_4
        BL       strcpy
//  184                     }
//  185                     UIF_CMDTAB[i].func(argc,argv);
??run_cmd_6:
        ADD      R1,SP,#+0
        MOVS     R0,R4
        MOVS     R2,#+28
        LDR.N    R3,??DataTable16_6
        MLA      R2,R2,R5,R3
        LDR      R2,[R2, #+16]
        BLX      R2
//  186                     return;
        B.N      ??run_cmd_7
//  187                 }
//  188                 else
//  189                 {
//  190                     printf(SYNTAX,argv[0]);
??run_cmd_5:
        LDR      R1,[SP, #+0]
        ADR.W    R0,SYNTAX
        BL       printf
//  191                     return;
        B.N      ??run_cmd_7
//  192                 }
//  193             }
//  194         }
//  195         printf(INVCMD,argv[0]);
??run_cmd_4:
        LDR      R1,[SP, #+0]
        ADR.W    R0,INVCMD
        BL       printf
//  196         printf(HELPMSG);
        ADR.W    R0,HELPMSG
        BL       printf
//  197     }
//  198 }
??run_cmd_1:
??run_cmd_7:
        ADD      SP,SP,#+44
        POP      {R4,R5,PC}       ;; return
//  199 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  200 uint32
//  201 get_value (char *s, int *success, int base)
//  202 {
get_value:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  203     uint32 value;
//  204     char *p;
//  205 
//  206     value = strtoul(s,&p,base);
        ADD      R1,SP,#+0
        MOVS     R0,R4
        BL       strtoul
//  207     if ((value == 0) && (p == s))
        CMP      R0,#+0
        BNE.N    ??get_value_0
        LDR      R1,[SP, #+0]
        CMP      R1,R4
        BNE.N    ??get_value_0
//  208     {
//  209         *success = FALSE;
        MOVS     R0,#+0
        STR      R0,[R5, #+0]
//  210         return 0;
        MOVS     R0,#+0
        B.N      ??get_value_1
//  211     }
//  212     else
//  213     {
//  214         *success = TRUE;
??get_value_0:
        MOVS     R1,#+1
        STR      R1,[R5, #+0]
//  215         return value;
??get_value_1:
        POP      {R1,R4,R5,PC}    ;; return
//  216     }
//  217 }
//  218 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  219 void
//  220 uif_cmd_help (int argc, char **argv)
//  221 {
uif_cmd_help:
        PUSH     {R4,LR}
        SUB      SP,SP,#+8
//  222     int index;
//  223     
//  224     (void)argc;
//  225     (void)argv;
//  226     
//  227     printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  228     for (index = 0; index < UIF_NUM_CMD; index++)
        MOVS     R4,#+0
        B.N      ??uif_cmd_help_0
//  229     {
//  230         printf(HELPFORMAT,
//  231             UIF_CMDTAB[index].cmd,
//  232             UIF_CMDTAB[index].description,
//  233             UIF_CMDTAB[index].cmd,
//  234             UIF_CMDTAB[index].syntax);
??uif_cmd_help_1:
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R4,R1
        LDR      R0,[R0, #+24]
        STR      R0,[SP, #+0]
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R4,R1
        LDR      R3,[R0, #+0]
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R4,R1
        LDR      R2,[R0, #+20]
        MOVS     R0,#+28
        LDR.N    R1,??DataTable16_6
        MLA      R0,R0,R4,R1
        LDR      R1,[R0, #+0]
        ADR.W    R0,HELPFORMAT
        BL       printf
//  235     }
        ADDS     R4,R4,#+1
??uif_cmd_help_0:
        LDR.N    R0,??DataTable16_5
        LDR      R0,[R0, #+0]
        CMP      R4,R0
        BLT.N    ??uif_cmd_help_1
//  236     printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  237 }
        POP      {R0,R1,R4,PC}    ;; return
//  238 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  239 void
//  240 uif_cmd_set (int argc, char **argv)
//  241 {
uif_cmd_set:
        PUSH     {R4-R6,LR}
        MOVS     R5,R0
        MOVS     R6,R1
//  242     int index;
//  243 
//  244     printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  245     if (argc == 1)
        CMP      R5,#+1
        BNE.N    ??uif_cmd_set_0
//  246     {
//  247         printf("Valid 'set' options:\n");
        ADR.W    R0,`?<Constant "Valid \\'set\\' options:\\n">`
        BL       printf
//  248         for (index = 0; index < UIF_NUM_SETCMD; ++index)
        MOVS     R4,#+0
        B.N      ??uif_cmd_set_1
//  249         {
//  250             printf(OPTFMT,UIF_SETCMDTAB[index].option);
??uif_cmd_set_2:
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R4,R1
        LDR      R1,[R0, #+0]
        ADR.W    R0,OPTFMT
        BL       printf
//  251             printf("%s\n",UIF_SETCMDTAB[index].syntax);
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R4,R1
        LDR      R1,[R0, #+16]
        ADR.N    R0,??DataTable16_1  ;; "%s\n"
        BL       printf
//  252         }
        ADDS     R4,R4,#+1
??uif_cmd_set_1:
        LDR.N    R0,??DataTable16_8
        LDR      R0,[R0, #+0]
        CMP      R4,R0
        BLT.N    ??uif_cmd_set_2
//  253         printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  254         return;
        B.N      ??uif_cmd_set_3
//  255     }
//  256 
//  257     if (argc != 3)
??uif_cmd_set_0:
        CMP      R5,#+3
        BEQ.N    ??uif_cmd_set_4
//  258     {
//  259         printf("Error: Invalid argument list\n");
        ADR.W    R0,`?<Constant "Error: Invalid argume...">`
        BL       printf
//  260         return;
        B.N      ??uif_cmd_set_3
//  261     }
//  262 
//  263     for (index = 0; index < UIF_NUM_SETCMD; index++)
??uif_cmd_set_4:
        MOVS     R4,#+0
        B.N      ??uif_cmd_set_5
??uif_cmd_set_6:
        ADDS     R4,R4,#+1
??uif_cmd_set_5:
        LDR.N    R0,??DataTable16_8
        LDR      R0,[R0, #+0]
        CMP      R4,R0
        BGE.N    ??uif_cmd_set_7
//  264     {
//  265         if (strcasecmp(UIF_SETCMDTAB[index].option,argv[1]) == 0)
        LDR      R1,[R6, #+4]
        MOVS     R0,#+20
        LDR.N    R2,??DataTable16_7
        MLA      R0,R0,R4,R2
        LDR      R0,[R0, #+0]
        BL       strcasecmp
        CMP      R0,#+0
        BNE.N    ??uif_cmd_set_6
//  266         {
//  267             if (((argc-1-1) >= UIF_SETCMDTAB[index].min_args) &&
//  268                 ((argc-1-1) <= UIF_SETCMDTAB[index].max_args))
        SUBS     R0,R5,#+2
        MOVS     R1,#+20
        LDR.N    R2,??DataTable16_7
        MLA      R1,R1,R4,R2
        LDR      R1,[R1, #+4]
        CMP      R0,R1
        BLT.N    ??uif_cmd_set_8
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R4,R1
        LDR      R0,[R0, #+8]
        SUBS     R1,R5,#+2
        CMP      R0,R1
        BLT.N    ??uif_cmd_set_8
//  269             {
//  270                 UIF_SETCMDTAB[index].func(argc,argv);
        MOVS     R1,R6
        MOVS     R0,R5
        MOVS     R2,#+20
        LDR.N    R3,??DataTable16_7
        MLA      R2,R2,R4,R3
        LDR      R2,[R2, #+12]
        BLX      R2
//  271                 return;
        B.N      ??uif_cmd_set_3
//  272             }
//  273             else
//  274             {
//  275                 printf(INVARG,argv[1]);
??uif_cmd_set_8:
        LDR      R1,[R6, #+4]
        ADR.W    R0,INVARG
        BL       printf
//  276                 return;
        B.N      ??uif_cmd_set_3
//  277             }
//  278         }
//  279     }
//  280     printf(INVOPT,argv[1]);
??uif_cmd_set_7:
        LDR      R1,[R6, #+4]
        ADR.W    R0,INVOPT
        BL       printf
//  281 }
??uif_cmd_set_3:
        POP      {R4-R6,PC}       ;; return
//  282 
//  283 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  284 void
//  285 uif_cmd_show (int argc, char **argv)
//  286 {
uif_cmd_show:
        PUSH     {R4-R6,LR}
        MOVS     R5,R0
        MOVS     R4,R1
//  287     int index;
//  288 
//  289     printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  290     if (argc == 1)
        CMP      R5,#+1
        BNE.N    ??uif_cmd_show_0
//  291     {
//  292         /*
//  293          * Show all Option settings
//  294          */
//  295         argc = 2;
        MOVS     R5,#+2
//  296         argv[2] = NULL;
        MOVS     R0,#+0
        STR      R0,[R4, #+8]
//  297         for (index = 0; index < UIF_NUM_SETCMD; index++)
        MOVS     R6,#+0
        B.N      ??uif_cmd_show_1
//  298         {
//  299             printf(OPTFMT,UIF_SETCMDTAB[index].option);
??uif_cmd_show_2:
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R6,R1
        LDR      R1,[R0, #+0]
        ADR.W    R0,OPTFMT
        BL       printf
//  300             UIF_SETCMDTAB[index].func(argc,argv);
        MOVS     R1,R4
        MOVS     R0,R5
        MOVS     R2,#+20
        LDR.N    R3,??DataTable16_7
        MLA      R2,R2,R6,R3
        LDR      R2,[R2, #+12]
        BLX      R2
//  301             printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  302         }
        ADDS     R6,R6,#+1
??uif_cmd_show_1:
        LDR.N    R0,??DataTable16_8
        LDR      R0,[R0, #+0]
        CMP      R6,R0
        BLT.N    ??uif_cmd_show_2
//  303         printf("\n");
        ADR.N    R0,??DataTable16  ;; "\n"
        BL       printf
//  304         return;
        B.N      ??uif_cmd_show_3
//  305     }
//  306 
//  307     for (index = 0; index < UIF_NUM_SETCMD; index++)
??uif_cmd_show_0:
        MOVS     R6,#+0
        B.N      ??uif_cmd_show_4
??uif_cmd_show_5:
        ADDS     R6,R6,#+1
??uif_cmd_show_4:
        LDR.N    R0,??DataTable16_8
        LDR      R0,[R0, #+0]
        CMP      R6,R0
        BGE.N    ??uif_cmd_show_6
//  308     {
//  309         if (strcasecmp(UIF_SETCMDTAB[index].option,argv[1]) == 0)
        LDR      R1,[R4, #+4]
        MOVS     R0,#+20
        LDR.N    R2,??DataTable16_7
        MLA      R0,R0,R6,R2
        LDR      R0,[R0, #+0]
        BL       strcasecmp
        CMP      R0,#+0
        BNE.N    ??uif_cmd_show_5
//  310         {
//  311             if (((argc-1-1) >= UIF_SETCMDTAB[index].min_args) &&
//  312                 ((argc-1-1) <= UIF_SETCMDTAB[index].max_args))
        SUBS     R0,R5,#+2
        MOVS     R1,#+20
        LDR.N    R2,??DataTable16_7
        MLA      R1,R1,R6,R2
        LDR      R1,[R1, #+4]
        CMP      R0,R1
        BLT.N    ??uif_cmd_show_7
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R6,R1
        LDR      R0,[R0, #+8]
        SUBS     R1,R5,#+2
        CMP      R0,R1
        BLT.N    ??uif_cmd_show_7
//  313             {
//  314                 printf(OPTFMT,UIF_SETCMDTAB[index].option);
        MOVS     R0,#+20
        LDR.N    R1,??DataTable16_7
        MLA      R0,R0,R6,R1
        LDR      R1,[R0, #+0]
        ADR.W    R0,OPTFMT
        BL       printf
//  315                 UIF_SETCMDTAB[index].func(argc,argv);
        MOVS     R1,R4
        MOVS     R0,R5
        MOVS     R2,#+20
        LDR.N    R3,??DataTable16_7
        MLA      R2,R2,R6,R3
        LDR      R2,[R2, #+12]
        BLX      R2
//  316                 printf("\n\n");
        ADR.N    R0,??DataTable16_2  ;; 0x0A, 0x0A, 0x00, 0x00
        BL       printf
//  317                 return;
        B.N      ??uif_cmd_show_3
//  318             }
//  319             else
//  320             {
//  321                 printf(INVARG,argv[1]);
??uif_cmd_show_7:
        LDR      R1,[R4, #+4]
        ADR.W    R0,INVARG
        BL       printf
//  322                 return;
        B.N      ??uif_cmd_show_3
//  323             }
//  324         }
//  325     }
//  326     printf(INVOPT,argv[1]);
??uif_cmd_show_6:
        LDR      R1,[R4, #+4]
        ADR.W    R0,INVOPT
        BL       printf
//  327 }
??uif_cmd_show_3:
        POP      {R4-R6,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16:
        DC8      "\n",0x0,0x0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_1:
        DC8      "%s\n"

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_2:
        DC8      0x0A, 0x0A, 0x00, 0x00

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_3:
        DC32     cmdline1

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_4:
        DC32     cmdline2

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_5:
        DC32     UIF_NUM_CMD

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_6:
        DC32     UIF_CMDTAB

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_7:
        DC32     UIF_SETCMDTAB

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16_8:
        DC32     UIF_NUM_SETCMD

        SECTION `.text`:CODE:NOROOT(1)
        DATA
`?<Constant "\\n">`:
        ; Initializer data, 2 bytes
        DC8 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Valid \\'set\\' options:\\n">`:
        ; Initializer data, 24 bytes
        DC8 86, 97, 108, 105, 100, 32, 39, 115, 101, 116
        DC8 39, 32, 111, 112, 116, 105, 111, 110, 115, 58
        DC8 10, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "%s\\n">`:
        ; Initializer data, 4 bytes
        DC8 37, 115, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Error: Invalid argume...">`:
        ; Initializer data, 32 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 73, 110, 118
        DC8 97, 108, 105, 100, 32, 97, 114, 103, 117, 109
        DC8 101, 110, 116, 32, 108, 105, 115, 116, 10, 0
        DC8 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\n\\n">`:
        ; Initializer data, 4 bytes
        DC8 10, 10, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
HELPMSG:
        ; Initializer data, 24 bytes
        DC8 69, 110, 116, 101, 114, 32, 39, 104, 101, 108
        DC8 112, 39, 32, 102, 111, 114, 32, 104, 101, 108
        DC8 112, 46, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
INVARG:
        ; Initializer data, 32 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 73, 110, 118
        DC8 97, 108, 105, 100, 32, 97, 114, 103, 117, 109
        DC8 101, 110, 116, 58, 32, 37, 115, 10, 0, 0
        DC8 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
INVALUE:
        ; Initializer data, 28 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 73, 110, 118
        DC8 97, 108, 105, 100, 32, 118, 97, 108, 117, 101
        DC8 58, 32, 37, 115, 10, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
INVCMD:
        ; Initializer data, 28 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 78, 111, 32
        DC8 115, 117, 99, 104, 32, 99, 111, 109, 109, 97
        DC8 110, 100, 58, 32, 37, 115, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
HELPFORMAT:
        ; Initializer data, 20 bytes
        DC8 37, 56, 115, 32, 32, 37, 45, 50, 53, 115
        DC8 32, 37, 115, 32, 37, 115, 10, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
SYNTAX:
        ; Initializer data, 32 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 73, 110, 118
        DC8 97, 108, 105, 100, 32, 115, 121, 110, 116, 97
        DC8 120, 32, 102, 111, 114, 58, 32, 37, 115, 10
        DC8 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
INVOPT:
        ; Initializer data, 40 bytes
        DC8 69, 114, 114, 111, 114, 58, 32, 32, 73, 110
        DC8 118, 97, 108, 105, 100, 32, 115, 101, 116, 47
        DC8 115, 104, 111, 119, 32, 111, 112, 116, 105, 111
        DC8 110, 58, 32, 37, 115, 10, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
OPTFMT:
        ; Initializer data, 8 bytes
        DC8 37, 49, 50, 115, 58, 32, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  328 
//  329 /********************************************************************/
// 
//   160 bytes in section .bss
// 1 232 bytes in section .text
// 
// 1 232 bytes of CODE memory
//   160 bytes of DATA memory
//
//Errors: none
//Warnings: none
