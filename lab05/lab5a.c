int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}
#define STDIN_FD  0
#define STDOUT_FD 1

int dectoint(char str[], int ini){
	int res = 0;
	int pot = 1;
	for(int i = 1; i < 4; i++){
		pot*=10;
	}
	
	for(int i = ini+1; pot != 0; pot /= 10, i++){
		res += pot * (str[i] - '0');
	}

	if(str[ini] == '-') res = -res;

	return res;
}

void inttobin(int a, char str[]){
	int aux = a;
	if(a < 0){
		aux = ~(a);
	}
	int pos = 31;
	for(int i = pos; i >= 0; i--){
		if(a >= 0){
			str[i] = '0' + aux % 2;
		}
		else{
			str[i] = '1' - aux % 2;
		}
		aux/=2;
	}
	str[32] = '\n';
}

int bintoint(char str[]){
  int res = 0;
  int pot = 1;
  for(int i = 31; i >= 0; i--){
    res += (str[i] - '0') * pot;
    pot *= 2;
  }
  return res;
}

void pack(int input, int start_bit, int end_bit, char str[]){

  int lsb = end_bit-start_bit+1;
	char strbin[50];
	inttobin(input, strbin);

    int j = 31-start_bit;
    for(int i = 31; i > 31-lsb; i--){
        str[j] = strbin[i];
        j--;
    }

}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int main(){
	char buffer[50];
	int sz = read(STDIN_FD, buffer, 50);

	int n1 = dectoint(buffer, 0);
	int n2 = dectoint(buffer, 6);
	int n3 = dectoint(buffer, 12);
	int n4 = dectoint(buffer, 18);
	int n5 = dectoint(buffer, 24);

  char ans[50];
  pack(n1, 0, 2, ans);
  pack(n2, 3, 10, ans);
  pack(n3, 11, 15, ans);
  pack(n4, 16, 20, ans);
  pack(n5, 21, 31, ans);
  
  hex_code(bintoint(ans));

	return 0;
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}
