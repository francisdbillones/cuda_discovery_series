__global__ void saxpy(const int* x, const int* y, int* out, const int a, const int N){
	for (int i = blockIdx.x * blockDim.x + threadIdx.x;
		i < N;
		i += gridDim.x * blockDim.x
	) {
		out[i] = a * x[i] + y[i];
	}
}
