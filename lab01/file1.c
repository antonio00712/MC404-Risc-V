extern void write(int __fd, const void *__buf, int __n);
extern int read(int __fd, const void *__buf, int __n);

int main(void) {
    char input_buffer[10];
    int n = read(0, (void*) input_buffer, 10);

    int s1 = input_buffer[0] - '0';
    int s2 = input_buffer[4] - '0';
    char op = input_buffer[2];
    int ans = 0;

    if(op == '+'){
        ans = s1 + s2;
    }else if(op == '-'){
        ans = s1 - s2;
    }else{
        ans = s1 * s2;
    }

    char output_buffer[10];
    output_buffer[0] = ans + '0';
    output_buffer[1] = '\n';

    write(1, (void*) output_buffer, 10);

    return 0;
}
