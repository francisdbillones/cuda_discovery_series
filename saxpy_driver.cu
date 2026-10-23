#include <cstdio>
#include <cuda_runtime.h>


__global__ void saxpy(const int* x, const int* y, const int* out, const int a, const int N);
void benchmark_n(const int n);
void init_data(int* x, int* y, int n);
void verify_result(const int* x, const int* y, const int* out, const int a, const int n);


int main() {
	benchmark_n(1 << 24);
	benchmark_n(1 << 26);
	benchmark_n(1 << 28);
}


void benchmark_n(const int n){
	const size_t bytes = n * sizeof(int);

	int *x, *y, *out;
	cudaMallocManaged(&x, bytes);
	cudaMallocManaged(&y, bytes);
	cudaMallocManaged(&out, bytes);

	init_data(x, y, n);

	const int threads = 256;
	const int blocks = (n + threads - 1) / threads;

	saxpy<<<blocks, threads>>>(x, y, out, a, n);

	cudaDeviceSynchronize();

	verify_result(x, y, out, n);

	cudaFree(x);
	cudaFree(y);
	cudaFree(out);
}

void init_data(int* x, int* y, const int n){
	for (int i = 0; i < n; ++i){
		x[i] = (i % 200) - 100;
		y[i] = (i % 100) - 50;
	}
}

void verify_result(const int* x, const int* y, const int* out, const int a, const int n){
	int num_mismatches = 0;
	for (int i = 0; i < n; ++i){
		if (out[i] != a * x[i] + y[i]) {
			++num_mismatches;
			printf("Mismatch at %d: expected %d, got %d\n",
				i,
				a * x[i] + y[i],
				out[i]
			)
		}
	}

	printf("Total mismatches: %d\n", num_mismatches);
}
