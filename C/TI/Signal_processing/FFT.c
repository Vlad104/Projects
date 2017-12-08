#include "fpu_rfft.h"
#include "fpu_cfft.h"
#include "math.h"
#include "examples_setup.h"

#define EQ256 16
#define EQ64  16

#define TIME(A) A = (CpuTimer0Regs.TIM.bit.MSW << 16) + (0xFFFF - CpuTimer0Regs.TIM.bit.LSW)

#define RFFT_STAGES     4 //8
#define RFFT_SIZE       16 //(1 << RFFT_STAGES)
#define CFFT_STAGES     4
#define CFFT_SIZE       16
#define EPSILON         0.01

#pragma DATA_SECTION(RFFTin1Buff,"RFFTdata1")
float RFFTin1Buff[RFFT_SIZE];
#pragma DATA_SECTION(RFFTmagBuff,"RFFTdata2")
float RFFTmagBuff[RFFT_SIZE/2+1];
#pragma DATA_SECTION(RFFToutBuff,"RFFTdata3")
float RFFToutBuff[RFFT_SIZE];
#pragma DATA_SECTION(RFFTF32Coef,"RFFTdata4")
float RFFTF32Coef[RFFT_SIZE];

#pragma DATA_SECTION(CFFTin1Buff,"CFFTdata1")
float CFFTin1Buff[CFFT_SIZE];
#pragma DATA_SECTION(CFFTin2Buff,"CFFTdata2")
float CFFTin2Buff[CFFT_SIZE];
#pragma DATA_SECTION(CFFToutBuff,"CFFTdata3")
float CFFToutBuff[CFFT_SIZE];
#pragma DATA_SECTION(CFFTF32Coef,"CFFTdata4")
float CFFTF32Coef[CFFT_SIZE];

#pragma DATA_SECTION(BufferFFTt1,"Mat1_2kb")
float BufferFFTt1[EQ64][EQ256];
#pragma DATA_SECTION(BufferFFTt2,"Mat2_2kb")
float BufferFFTt2[EQ64][EQ256];
#pragma DATA_SECTION(BufferFFTw1,"Mat3_2kb")
float BufferFFTw1[EQ256][EQ64];
#pragma DATA_SECTION(BufferFFTw2,"Mat4_2kb")
float BufferFFTw2[EQ256][EQ64];
#pragma DATA_SECTION(BufferFFTw1_mag,"Mat5_1kb")
float BufferFFTw1_mag[EQ256][EQ64/2];
#pragma DATA_SECTION(BufferFFTw2_mag,"Mat6_1kb")
float BufferFFTw2_mag[EQ256][EQ64/2];
#pragma DATA_SECTION(Energy_0,"Mat7_1kb")
float Energy_0[EQ256][EQ64/2];
#pragma DATA_SECTION(Energy,"Mat8_1kb")
float Energy[EQ256][EQ64/2];

float Angle[EQ256][EQ64/2];

#define MAX_STRUCT_SIZE 110
#define MAX_STACK_POINTER 100

typedef struct {
    Uint16 cluster;
    float energy;
    float distance;
    float velocity;
    float angle;
} OUT_DATA;

OUT_DATA* Struct[MAX_STRUCT_SIZE];


float RadStep = 0.1963495408494f;  // Step to generate test bench waveform
float Rad = 0.0f;

RFFT_F32_STRUCT rfft;
RFFT_F32_STRUCT_Handle hnd_rfft = &rfft;
CFFT_F32_STRUCT cfft;
CFFT_F32_STRUCT_Handle hnd_cfft = &cfft;

#ifdef USE_TABLES
//Linker defined variables
extern uint16_t  FFTTwiddlesRunStart;
extern uint16_t  FFTTwiddlesLoadStart;
extern uint16_t  FFTTwiddlesLoadSize;
#endif //USE_TABLES

void init_fpu();
void timer0_init();
void signal_init_real();
void signal_init_comp();
void make_signal_1();
void make_signal_2();
void adaptive_threshold();
void argument();
void clustering();
void clustering_init(Uint16 * Stack[][EQ256], Uint16 * Mark[][2]);
void fft_t();
void fft_w();

Uint32 t1 = 0, t2 = 0, dt = 0;

void main(void)
{
    init_fpu();
    timer0_init();
    signal_init_real();
    signal_init_comp();

    Uint32 t1 = 0, t2 = 0, dt = 0;
    TIME(t1);
    //
    //TIME(t2);
    //dt = t2 - t1;
    //asm(" ESTOP0");

    fft_t(); //Step 1: Calculate rfft(264) x64

    fft_w(); //Step 2: Calculate cfft(64) x256

    adaptive_threshold(); //Step 3: Treshold

    clustering(); //Step 4: Clustering

    //Uint32 t1 = 0, t2 = 0, dt = 0;
    //TIME(t1);
    //
    TIME(t2);
    dt = t2 - t1;
    asm(" ESTOP0");

    asm(" ESTOP0");
    while(1) {};
}

void fft_t()
{
    Uint16 i, j;
    for (i = 0; i < EQ64; i++)
    {
        make_signal_1();       //input data for BufferFFTt1
        RFFT_f32(hnd_rfft);
        for (j = 0; j < EQ256/2; j++) {
            BufferFFTt1[i][2*j] = RFFToutBuff[j];    //complex data for BufferFFTt1
            BufferFFTt1[i][2*j+1] = RFFToutBuff[EQ256 - 1 - j]; //for bit reversing
        }

        make_signal_2();         //input data for BufferFFTt2
        RFFT_f32(hnd_rfft);
        for (j = 0; j < EQ256/2; j++) {
            BufferFFTt2[i][2*j] = RFFToutBuff[j];    //complex data for BufferFFTt2
            BufferFFTt2[i][2*j+1] = RFFToutBuff[EQ256 - 1 - j]; //for bit reversing
        }
    }
}

void fft_w()
{
    Uint16 i, j, ii = 0;
    for (i = 0; i < EQ256; i++)
    {
        ii = 2*i;

        for (j = 0; j < EQ64; j++) {      //input data for BufferFFTw1
            CFFTin1Buff[j] = BufferFFTt1[j][ii];
            CFFTin1Buff[j+1] = BufferFFTt1[j][ii+1];
        }

        CFFT_f32(hnd_cfft);                    // Calculate FFT
        CFFT_f32_mag(hnd_cfft);

        for (j = 0; j < EQ64; j++)             // save results
            //BufferFFTw1[i][j] = hnd_cfft->CurrentInPtr[j];
            BufferFFTw1[j][i] = hnd_cfft->CurrentInPtr[j];

        for (j = 0; j < EQ64/2; j++)
            //BufferFFTw1_mag[i][j] = hnd_cfft->CurrentOutPtr[j];  //magnitude data
            BufferFFTw1_mag[j][i] = hnd_cfft->CurrentOutPtr[j];  //magnitude data


        for (j = 0; j < EQ64; j++) {       //input data for BufferFFTw2
            CFFTin1Buff[j] = BufferFFTt2[j][ii];
            CFFTin1Buff[j+1] = BufferFFTt2[j][ii+1];
        }

        CFFT_f32(hnd_cfft);             // calculate FFT
        CFFT_f32_mag(hnd_cfft);

        for (j = 0; j < EQ64; j++)
            //BufferFFTw2[i][j] = hnd_cfft->CurrentInPtr[j];  //complex data
            BufferFFTw2[j][i] = hnd_cfft->CurrentInPtr[j];

        for (j = 0; j < EQ64/2; j++)
            //BufferFFTw2_mag[i][j] = hnd_cfft->CurrentOutPtr[j]; //magnitude data
            BufferFFTw2_mag[j][i] = hnd_cfft->CurrentOutPtr[j]; //magnitude data

        //Step 2.1: Calculate magnitude sum x256
        for (j = 0; j < EQ64/2; j++)   // summary magnitude matrix
            //Energy_0[i][j] = BufferFFTw1_mag[i][j] + BufferFFTw2_mag[i][j];
            Energy_0[j][i] = BufferFFTw1_mag[j][i] + BufferFFTw2_mag[j][i];
    }
}


void clustering_init(Uint16 * Stack[][EQ256], Uint16 * Mark[][2])
{
    Uint16 i,j;
    for (i = 0; i < MAX_STRUCT_SIZE; i++) {
            Struct[i]->cluster = 0;
            Struct[i]->energy = 0;
            Struct[i]->distance = 0;
            Struct[i]->velocity = 0;
            Struct[i]->angle = 0;
    }

    for (i = 0; i < MAX_STACK_POINTER; i++) {
        Stack[i][0] = 0;
        Stack[i][1] = 0;
    }

    for (i = 0; i < EQ64/2; i++)
        for (j = 0; j < EQ256; j++)
            Mark[i][j] = 0;
}


void adaptive_threshold()
{
        Uint16 i,j, k = 10;
        float S1, S2;
        for (i = 0; i < EQ64/2; i++) //построчный обход
            for (j = 0; j < EQ256; j++)
            {
                if (5-j <= 0 && j <= (EQ256-5)) {
                    S1 = Energy_0[i][j-5] + Energy_0[i][j-4] + Energy_0[i][j-3];
                    S1 /= 3;
                    S2 = Energy_0[i][j+3] + Energy_0[i][j+4] + Energy_0[i][j+5];
                    S2 /= 3;
                    if ( (k*S1 < Energy_0[i][j]) && (k*S2 < Energy_0[i][j]) )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j <= 2) {
                    S2 = Energy_0[i][3+j] + Energy_0[i][4+j] + Energy_0[i][5+j];
                    S2 /= 3;
                    if ( k*S2 < Energy_0[i][j] )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j >= EQ256-2) {
                    S1 = Energy_0[i][j-3] + Energy_0[i][j-4] + Energy_0[i][j-5];
                    S1 /= 3;
                    if ( k*S1 < Energy_0[i][j] )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j == 3) {
                    S1 = Energy_0[i][j-3];
                    S2 = Energy_0[i][j+3] + Energy_0[i][j+4] + Energy_0[i][j+5];
                    S2 /= 3;
                    if ( (k*S1 < Energy_0[i][j]) && (k*S2 < Energy_0[i][j]) )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j == 4) {
                    S1 = Energy_0[i][j-3] + Energy_0[i][j-4];
                    S1 /= 2;
                    S2 = Energy_0[i][j+3] + Energy_0[i][j+4] + Energy_0[i][j+5];
                    S2 /= 3;
                    if ( (k*S1 < Energy_0[i][j]) && (k*S2 < Energy_0[i][j]) )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j == EQ256 - 3) {
                    S1 = Energy_0[i][j-3] + Energy_0[i][j-4] + Energy_0[i][j-5];
                    S1 /= 3;
                    S2 = Energy_0[i][j+3];
                    if ( (k*S1 < Energy_0[i][j]) && (k*S2 < Energy_0[i][j]) )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }
                if (j == EQ256 - 4) {
                    S1 = Energy_0[i][j-3] + Energy_0[i][j-4] + Energy_0[i][j-5];
                    S1 /= 3;
                    S2 = Energy_0[i][j+3] + Energy_0[i][j+4];
                    S2 /= 2;
                    if ( (k*S1 < Energy_0[i][j]) && (k*S2 < Energy_0[i][j]) )
                        Energy[i][j] = (Uint32) Energy_0[i][j];
                    else
                        Energy[i][j] = 0;
                    continue;
                }  /**/
            }
}

void argument()
{
    int i, j;
    for(i = 0; i < EQ64/2; i++)
        for(j = 0; j < EQ256; j+=2)
            if(Energy[i][j] > 0)
                Angle[i][j] = atan( BufferFFTw1[i][j+1]/BufferFFTw1[i][j] ) - atan( BufferFFTw2[i][j+1]/BufferFFTw2[i][j] );
            else
                Angle[i][j] = 0;
}

void clustering()
{
    Uint16 Mark[EQ64/2][EQ256];
    Uint16 Stack[MAX_STACK_POINTER][2];
    clustering_init(Stack, Mark);
    Uint16 ii, jj, i, j, flag;
    Uint16 cluster = 0;
    Uint16 stack_pointer;

    for (ii = 0; ii < EQ64; ii++)
        for (jj = 0; jj < EQ64/2; jj++) {
            stack_pointer = 1;
            i = ii;
            j = jj;
            flag = 0;
            while (stack_pointer > 0)
            {
                if (flag) {
                    i = Stack[stack_pointer][0];
                    j = Stack[stack_pointer][1];
                }
                flag = 1;

                if ( j < EQ256-1 && i < EQ64/2-1 && Mark[i][j] == 0 && Energy[i][j] > 0 )
                {
                    Struct[cluster]->cluster = cluster;
                    Struct[cluster]->energy += Energy_0[i][j];
                    Struct[cluster]->distance += j*Energy_0[i][j];
                    Struct[cluster]->velocity += (i - EQ64/4)*Energy_0[i][j];
                    Struct[cluster]->angle += Angle[i][j]*Energy_0[i][j];

                    Mark[i][j] = 1;
                    stack_pointer--;

                    if ( j + 1 < EQ256 && Mark[i][j+1] == 0 && Energy[i][j+1] > 0 ) // && abs(Angle[i][j] - Angle[i][j+1]) < 2 )
                    {
                        stack_pointer++;
                        Stack[stack_pointer][0] = i;
                        Stack[stack_pointer][1] = j+1;
                    }
                    if ( j - 1 >= 0 && Mark[i][j-1] == 0 && Energy[i][j-1] > 0 ) // && abs(Angle[i][j] - Angle[i][j-1]) < 2 )
                    {
                        stack_pointer++;
                        Stack[stack_pointer][0] = i;
                        Stack[stack_pointer][1] = j-1;
                    }
                    if ( i + 1 < EQ64/2 && Mark[i+1][j] == 0 && Energy[i+1][j] > 0 ) // && abs(Angle[i][j] - Angle[i+1][j]) < 2 )
                    {
                        stack_pointer++;
                        Stack[stack_pointer][0] = i+1;
                        Stack[stack_pointer][1] = j;
                    }
                    if ( i -1 >= 0 && Mark[i-1][j] == 0 && Energy[i-1][j] > 0 ) // && abs(Angle[i][j] - Angle[i-1][j]) < 2 )
                    {
                        stack_pointer++;
                        Stack[stack_pointer][0] = i-1;
                        Stack[stack_pointer][1] = j;
                    }
                }
                else
                    break;
            }
            if (cluster < MAX_STRUCT_SIZE && Struct[cluster]->energy > 0)
                cluster++;
        }

    for (i = 0; i < MAX_STRUCT_SIZE; i++)
        if (Struct[cluster]->energy > 0)
        {
            Struct[i]->distance /= Struct[i]->energy;
            Struct[i]->velocity /= Struct[i]->energy;
            Struct[i]->angle /= Struct[i]->energy;
        }
}

/////////////////////////////////////////////////////////

void timer0_init()
{
    CpuTimer0Regs.PRD.all  = 0xFFFFFFFF;
    CpuTimer0Regs.TPR.all  = 0;  // Initialize pre-scale
    CpuTimer0Regs.TPRH.all = 0;
    CpuTimer0Regs.TCR.bit.TSS = 1;   // 1 = Stop timer
    CpuTimer0Regs.TCR.bit.TRB = 1;   // 1 = Reload timer
    CpuTimer0Regs.TCR.all = 0x4000;
}

void make_signal_1()
{
    Uint16 i;
    Rad = 0.0f;
    for (i = 0; i < RFFT_SIZE; i++) {
        RFFTin1Buff[i] = sin(Rad);
        Rad = Rad + RadStep;
    }
}

void make_signal_2()
{
    Uint16 i;
    Rad = 0.0f;
    float x = 0.1;
    for (i = 0; i < RFFT_SIZE; i++) {
        RFFTin1Buff[i] = sin(Rad + x);
        Rad = Rad + RadStep;
    }
}

void signal_init_real()
{
    Uint16 i;
    for(i=0; i < RFFT_SIZE; i++)
            RFFTin1Buff[i] = 0.0f;

    Rad = 0.0f;
    for(i=0; i < RFFT_SIZE; i++){
        RFFTin1Buff[i] = sin(Rad) + sin(2*Rad); //Real input signal
        Rad = Rad + RadStep;
    }

        hnd_rfft->FFTSize   = RFFT_SIZE;
        hnd_rfft->FFTStages = RFFT_STAGES;
        hnd_rfft->InBuf     = &RFFTin1Buff[0];
        hnd_rfft->OutBuf    = &RFFToutBuff[0];
        hnd_rfft->MagBuf    = &RFFTmagBuff[0];
    #ifdef USE_TABLES
        hnd_rfft->CosSinBuf = RFFT_f32_twiddleFactors;  //Twiddle factor buffer
    #else
        hnd_rfft->CosSinBuf = &RFFTF32Coef[0];  //Twiddle factor buffer
        RFFT_f32_sincostable(hnd_rfft);         //Calculate twiddle factor
    #endif //USE_TABLES

        for (i=0; i < RFFT_SIZE; i++)
              RFFToutBuff[i] = 0;               //Clean up output buffer

        for (i=0; i <= RFFT_SIZE/2; i++)
             RFFTmagBuff[i] = 0;
}

void signal_init_comp()
{
    Uint16 i;
    for(i=0; i < (CFFT_SIZE*2); i=i+2){
        CFFTin1Buff[i] = 0.0f;
        CFFTin1Buff[i+1] = 0.0f;
        CFFTin2Buff[i] = 0.0f;
        CFFTin2Buff[i+1] = 0.0f;
        CFFToutBuff[i] = 0.0f;
        CFFToutBuff[i+1] = 0.0f;
    }

    Rad = 0.0f;
    for(i=0; i < (CFFT_SIZE*2); i=i+2){
        CFFTin1Buff[i]   = sin(Rad) + cos(Rad*2.3567);       // Real Part
        CFFTin1Buff[i+1] = cos(Rad*8.345) + sin(Rad*5.789);  // Imaginary Part

        CFFTin2Buff[i]   = CFFTin1Buff[i];          // Not used in calculation
        CFFTin2Buff[i+1] = CFFTin1Buff[i+1];        // Not used in calculation
        Rad = Rad + RadStep;
    }

    hnd_cfft->InPtr   = CFFTin1Buff;
    hnd_cfft->OutPtr  = CFFToutBuff;
    hnd_cfft->Stages  = CFFT_STAGES;  // FFT stages
    hnd_cfft->FFTSize = CFFT_SIZE;    // FFT size
#ifdef USE_TABLES
    hnd_cfft->CoefPtr = CFFT_f32_twiddleFactors;  //Twiddle factor table
#else
    hnd_cfft->CoefPtr = CFFTF32Coef;  //Twiddle factor table
    CFFT_f32_sincostable(hnd_cfft);   // Calculate twiddle factor
#endif //USE_TABLES

/*
#ifdef USE_TABLES
    CFFT_f32t(hnd_cfft);                   // Calculate FFT
#else
    CFFT_f32(hnd_cfft);                    // Calculate FFT
#endif //USE_TABLES

    // Calculate Magnitude:
#ifdef __TMS320C28XX_TMU__ //defined when --tmu_support=tmu0 in the project properties
    CFFT_f32_mag_TMU0(hnd_cfft);
#else
    CFFT_f32_mag(hnd_cfft);
#endif

    // Calculate Phase:
    // To avoid overwriting the magnitude, change the output buffer for the phase()
    hnd_cfft->CurrentOutPtr=CFFTin2Buff;

#ifdef __TMS320C28XX_TMU__ //defined when --tmu_support=tmu0 in the project properties
    CFFT_f32_phase_TMU0(hnd_cfft);
#else
    CFFT_f32_phase(hnd_cfft);
#endif

*/
}

void init_fpu()
{
#ifdef FLASH
    EALLOW;
    Flash0EccRegs.ECC_ENABLE.bit.ENABLE = 0;
    memcpy((uint32_t *)&RamfuncsRunStart, (uint32_t *)&RamfuncsLoadStart,
            (uint32_t)&RamfuncsLoadSize );
    FPU_initFlash();
#ifdef USE_TABLES
    memcpy((uint32_t *)&FFTTwiddlesRunStart, (uint32_t *)&FFTTwiddlesLoadStart,
            (uint32_t)&FFTTwiddlesLoadSize );
#endif //USE_TABLES
#endif //FLASH

    FPU_initSystemClocks();
    DINT;
    FPU_initEpie();

#ifdef _STANDALONE
#ifdef _FLASH
    //  Send boot command to allow the CPU02 application to begin execution
    IPCBootCPU2(C1C2_BROM_BOOTMODE_BOOT_FROM_FLASH);
#else
    IPCBootCPU2(C1C2_BROM_BOOTMODE_BOOT_FROM_RAM);
#endif
#endif

    EINT;   // Enable Global interrupt INTM
    ERTM;   // Enable Global realtime interrupt DBGM
}
