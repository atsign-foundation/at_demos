# GSM @Profile

## Profile details

![@Profile diagram](profile.jpg)

The diagram describes the file structure of the @Profile: 

* The design and comments here assume knowledge of SIMs and file types and
referencing.
  * USIM filesystem is described in TS131.102
  * File types ISO 7816-4, TS 102.221
  * eSIMs are described in SGP02
* The filesystem design is deliberate to minimize the file structure and keep
the referencing of it flat i.e. MF->DF@
* In the past it was always assumed to keep the files under the EDF, however
this makes the referencing more complicated for the device using AT commands.
* Because the eSIM has only one full filesystem per subscription it makes
more sense to keep the files under the MF.

### Directory structure description

* The Master file 3F00 has a Dedicated file DF 8F40
* It is a non standardised file and assumes the handset
client is aware of the file ID, to reference
  * Note DF last byte 40 is @ in ascii hex -)
* There are two Elementary files under the DF 9F40 and 9F41
  * 9F40 is the @ stores, it assumes 10 @’s can be stored
  * 9F41 is the @Key store, the storage of the transient AES keys
  * The file size is 64 bytes to allow AES keys of up to 512bits to be stored
    * Zariot is fully aware 256bit keys are in common use currently
* The @ store is 1:1 referenced
* Record 1 of 8F40 references 8F41 record 1
  * This means the AES key for @#1 is record 1 of 8F41
  * It assumes that @’s only have one AES keyset and no group AES keysets
  exists
* The EF’s are file read and update APIN1
* DF’s are read only
  * APIN1 is for reading the file structure and update to the EF’s 
  * Create, delete ADM1
    * The handset client will not have access to create filesystems for
    security
    * To stop malicious app usage access 
* The filesystem can be accessed on any logical channel and is recommended
as not to effect the terminals own access to the filesystem i.e. file pointer
and re-entrancy issues (See 3GPP file access guidelines in TS 102.221).

### AT Commands

To access the SIM you have two options:
* AT+CRSM – Restricted SIM access
* AT+CSIM – Generic SIM access  

**If you use “minicom” to test make sure you use the -w option for wrapping,
else commands will not work!! Either the response too short, or command not
long enough. You will get an error and it isn’t obvious!!!!**

e.g. `sudo minicom -w -D /dev/ttyS0`

### AT+CRSM

* This would be the ideal option
* It doesn’t affect normal option of the SIM and, SIM presence detection,
i.e. polling.
* When tested against the interface it was found to be unreliable on the
SimCom7600G
  * SIMcom is based on Qualcom snapdragon
  * If it is unreliable on this it will be for most devices for all but
  simple operations like reading the phonebook.
* Select by path wasn’t working i.e. 3f00->8f40->9f40 or 9f41
* Suspected that the file pointer which runs on a logical channel
i.e the default which then on subsequent commands can change because the
chip itself is updating files.
* The best solution to solve this is to use the AT+CSIM AT command but note
warnings!

### AT+CSIM

Generic file access means we can do anything that a normal APDU can do
i.e. normal terminal interface.
* Note this has risks.
* In a SIM is a file pointer/session context 
* This operates on a logical channel (see TS 102.221).
* The default channel is 00, this is what the terminal will be using.
* If you use the default channel you will have an issue.
* Select a file the OS then does an update the file pointer changes,
when you try to read the file you think you are reading it won’t be or
it will result in an error.
* The solution is to run your session on another logical channel!

Manage channel
* Defined in open card platform command and etsi 3GPP TS102.221
* The Command: `AT+CSIM=10,"0070000001"`
  * Note 10 = length of command in nibbles not bytes!!! Then
  CMD(00),Instruction(70),P1(00),P2(00),Le(bytes response)
  * Response (e.g. `+CSIM: 6,"029000"`) is the logical channel number which
  is the lower two bits of the Command, i.e. 0x2 where is the logical
  channel, the SIM RTNs the first free one and the terminal itself may use
  more than one…
  * This keeps the context of your requests and stops chip resetting etc and
  no errors ;-)

Select by Path
* Lets keep this simple: select files before read or update
* This sets the file pointer to the file and directory we want to be able to
read a file.
* There is an example file 9f41 EF@keys
* Select command is instruction 0xA4
* Command would be 0x00 but we need a logical channel!
* So the command that would be 00 A4 becomes 02 A4, simples
* Turning this into a AT command gives the following:
`AT+CSIM=18,"02A4080C048F409F40"`
  * Where 02 is the logical channel and 8F40->9f40 (EF@Store) is the file path
  * 08 select by path from MF see table 11.1 of TS 102.221
  * This is a select by path command from the MF being 3F00 which is also
  known as the master file. The MF file ID is not mentioned, because it is
  implicit.
* Example response: `+CSIM: 4,"9000"`

### Read Record

The files used in this function are Record based. The command looks like this:

`AT+CSIM=10,"02B20104FF"`

02 logical channel and command  
B2 read record  
01 record number   
04 absolute mode  
FF number of bytes expected in the response  

Response looks like:

```
+CSIM: 514,"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9000"
```

### Update Record

`AT+CSIM=520,"02DC0104FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"`

Response:

```
+CSIM: 4,"9000"
```

4 nibbles 9000 means SW1 SW2 OK note 6A 86 etc is a failure 61 xx procedure
etc.

### Other Commands for EF@keys file

`AT+CSIM=18,"02A4080C048F409F41"` Select EF@Keys

`AT+CSIM=10,"02B2010440"` read record 1 64bytes of data (0x40)

Response:

```
+CSIM: 132,"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9000"
```

Update:

`AT+CSIM=138,"02DC010440FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"`

Response:

```
+CSIM: 4,"9000"OK
```

### Useful documents

* [SIM7500_SIM7600 Series AT Command Manual (pdf)](https://www.waveshare.net/w/upload/6/68/SIM7500_SIM7600_Series_AT_Command_Manual_V2.00.pdf)
* 3GPP TS 102.221 – UICC specification
* 3GPP TS27.007 – AT command set
