#include "stm32f4xx.h"
#include "system_stm32f4xx.h"
#include "FreeRTOS.h"
#include "task.h"

void initGPIO(void);
void vLED1(void*);
void vLED2(void*);

int main(void) {
    initGPIO();

    xTaskCreate(vLED1, "LED1", 32, NULL, 1, NULL);
    xTaskCreate(vLED2, "LED2", 32, NULL, 1, NULL);

    vTaskStartScheduler();

    while (1);
}

void initGPIO(void) {
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;

    GPIOD->MODER |= GPIO_MODER_MODER12_0 | 
                    GPIO_MODER_MODER13_0;

    GPIOD->OTYPER &= ~(GPIO_OTYPER_OT_12 | 
                       GPIO_OTYPER_OT_13);

    GPIOD->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR12_0 | GPIO_OSPEEDER_OSPEEDR12_1 |
                      GPIO_OSPEEDER_OSPEEDR13_0 | GPIO_OSPEEDER_OSPEEDR13_1;
}

void vLED1(void *p) {
    while (1) {
        *(__IO uint32_t*)&GPIOD->BSRRL = GPIO_BSRR_BS_12;
        vTaskDelay(1000);
        
        *(__IO uint32_t*)&GPIOD->BSRRL = GPIO_BSRR_BR_12;
        vTaskDelay(1000);
    }
}

void vLED2(void *p) {
    while (1) {
        *(__IO uint32_t*)&GPIOD->BSRRL = GPIO_BSRR_BR_13;
        vTaskDelay(1000);
        
        *(__IO uint32_t*)&GPIOD->BSRRL = GPIO_BSRR_BS_13;
        vTaskDelay(1000);
    }
}