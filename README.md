# EIS Server Configuration
#### This was created after patch 1.1.2 so please be aware things may change

Know that I am trying to make this as transparent for anyone using this. It is quite doable however I wanted to try to automate the process as much as possible.

My system is running on Centos 7 attached to our ldap and oracle database.

1) Use an account with sudo priviledges to perform all your modifications.  
2) Due to  the software warnings surrounding Java 7 after Update 80 this is scripted to 79 (which is convenient as it is the last publicly available one.)  
 * Note- my sysadmin didn't get this note so my production server is coded for 97 and we have not seen any errors at this point.


### SystemD References
[SystemD Service](http://0pointer.de/public/systemd-man/systemd.service.html)  
[SystemD Exec](http://0pointer.de/public/systemd-man/systemd.exec.html)  
