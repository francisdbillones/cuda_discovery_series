__global__ void saxpy(int* x, int* y, int* out, int a, int N){
	for (int i = blockIdx.x * blockDim.x + threadIdx.x;
		i < N;
		i += gridDim.x * blockDim.x
	) {
		out[i] = a * x[i] + y[i];
	}
}
