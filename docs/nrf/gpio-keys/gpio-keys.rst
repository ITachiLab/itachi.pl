GPIO input under Zephyr OS
==========================

How to read state of GPIO inputs under Zephyr OS? The answer can be found in sample codes located in the `sdk-zephyr <gpio sample_>`_ repository. The process usually involves retrieving a DT node of a desired GPIO pin, performing a couple of checks, and optionally configuring interrupts. Everything can be done with functions exposed by the GPIO driver API. Although it doesn't sound like something complex to do, nor it actually is, but when looking at the code it seems to be overwhelmed by all of that boilerplate code. Thankfully someone already spot this, and created an appropriate device driver. It's even present in the repository, and used in the DTS file of my development board, but not correctly.

.. warning:: When linking source codes, I'm always linking to the nRF Zephyr SDK repository instead of the official repository for Zephyr OS. The reason is that nRF Connect doesn't necessarily rely on the latest releases of Zephyr, so some features could be present in the neweset version of Zephyr, but are not yet available in nRF Connect.

Board DTS
---------

I started my journey from the DTS file for my board, it is located at `boards/arm/nrf52840dk_nrf52840/nrf52840dk_nrf52840.dts <nrf52840_nrf52840.dts_>`_. In the root node there is a ``buttons`` node which looks promising, it has a driver attached (``gpio-keys``), and definitions of four buttons referring to GPIOs, exactly like it is on the board. So, it should work out of the box, right? Only in theory. I couldn't find any examples or documentation describing how to use these GPIO keys, and the only example explaining how to use GPIOs for inputs was the one I linked above. It's not a bad approach, though, but it's a low-level approach requiring lots of boilerplate code.

input_gpio_keys.c
-----------------

The driver file is located at `drivers/input/input_gpio_keys.c <input_gpio_keys.c_>`_. The initialization function (``gpio_keys_init``) executes the same set of functions as the sample code linked above, and even more. What's interesting is how interrupts are handled. The ``gpio_keys_change_call_deferred`` function is the interrupt's entry point, but the actual work is done in ``gpio_keys_change_deferred`` which is a job submitted to the system workqueue when the interrupt (key press) happens.

The fact that key presses are processed in the workqueue is important, especially when using this driver in a multithreaded environment. More about `Workqueue`_ can be read in the Zephyr documentation, but what's the most relevant now is to remember that the system workqueue's thread is usually a cooperative thread with a very low priority (-1 or -2, depending on other configuration options), thus it can be easily starved when other threads are also cooperative, and are not yielding enough or at all. I had this situation recently, the key presses weren't recorded as expected, and the problem was that I didn't call ``k_yield()`` in my thread.

Enabling the driver
+++++++++++++++++++





Under ``fsjfklsa``

.. target-notes::


.. _`gpio sample`: https://github.com/nrfconnect/sdk-zephyr/blob/main/samples/basic/button/src/main.c
.. _`nrf52840_nrf52840.dts`: https://github.com/nrfconnect/sdk-zephyr/blob/v3.3.99-ncs1/boards/arm/nrf52840dk_nrf52840/nrf52840dk_nrf52840.dts
.. _`input_gpio_keys.c`: https://github.com/nrfconnect/sdk-zephyr/blob/v3.3.99-ncs1/drivers/input/input_gpio_keys.c
.. _`Workqueue`: https://docs.zephyrproject.org/latest/kernel/services/threads/workqueue.html
