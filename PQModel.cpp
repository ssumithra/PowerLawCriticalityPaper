#include <iostream>
using std::cerr;
using namespace std;
#include <fstream>
using std::ofstream;
#include <cstdlib>       // for exit function
#include <ctime>


// parameter definitions
#define N 1024    // system size//#define means 'assign value to the global variable that follows.. so wherever you write N it will be 128 automatically
#define p_range 100000  // no. of p values in range 0-1
#define q_range 10000 // no. of q values in range 0-1
#define T 10000      // No. of time steps
#define rep 5 //no. replicates


//====== function to initialize the matrix ===============//
void create_random_matrix(int*U,float x) {      // x is the initial density of the system

	int i1, i2;

	for (i1 = 0; i1 < N; i1++) {
		for (i2 = 0; i2 < N; i2++) {
			float number = rand()/(float)RAND_MAX;
			if (number<x) U[i1*N+i2]=1;
			else U[i1*N+i2]=0;
		}
	}

}


//=======================average density=========================//
float density(int* A){                       // it calculates the average density of N*N plot
	int i,j;
	float sum=0;
	for(i=0;i<N;++i){
		for(j=0;j<N;++j){
			sum+= A[i*N+j];
		}
	}
	float average= sum/(N*N);
return average;
}

//=========================average along rows======================//
  /* if we have a matrix with each row representing density of one realization, this function calculates
  the average density over all rows i.e. all realizations */

void average_along_row(float* A,float*A1){
	int l,k;
	float sum=0;

	for(k=0;k<p_range;++k){
		sum=0;
		for(l=0;l<rep;++l){
			sum+=A[l*p_range+k];
		}
		A1[k]=sum/rep;
	}

}

//====================select random site==============================//
void select_neighbor_of_site(int i ,int j , int*neighbor){
	int left,right,bottom,top ;
	int in = i ,jn = j;

	float test = rand()/(float)RAND_MAX ;

	if (i==0) top=N-1;
	else top = i-1;

	if (i==N-1) bottom = 0;
	else bottom = i+1 ;

	if (j==0) left = N-1;
	else left = j-1 ;

	if (j==N-1) right = 0;
	else right = j+1;

	if (test <= 0.25) in = top;
	else if ( test <= 0.5) in = bottom;
	else if ( test <=0.75) jn =left;
	else jn = right;

	neighbor[0] = in;
	neighbor[1] = jn;

}

//========select neighbor of pair=====================================//
int select_neighbor_of_pair(int in ,int jn, int i, int j){
	int left,right,top,bottom,leftn,rightn,topn,bottomn , neighbor_of_pair;

	if (i==0) top=N-1;
	else top = i-1;

	if (i==N-1) bottom = 0;
	else bottom = i+1 ;

	if (j==0) left = N-1;
	else left = j-1 ;

	if (j==N-1) right = 0;
	else right = j+1;

	if (in==0) topn=N-1;
	else topn = in-1;

	if (in==N-1) bottomn = 0;
	else bottomn = in+1 ;

	if (jn==0) leftn = N-1;
	else leftn = jn-1 ;

	if (jn==N-1) rightn = 0;
	else rightn = jn+1;

	int nn[6] ,c=0;

	if ((top*N +j) != (in*N+jn)) {
		nn[c]=top*N + j;
		c+=1;
	}
	if ((bottom*N + j) != (in*N+jn)) {
		nn[c]=bottom*N  + j;
		c+=1;
	}
	if ((i*N +right) != (in*N+jn)) {
		nn[c]= i*N + right;
		c+=1;
	}
	if ((i*N +left) != (in*N+jn)) {
		nn[c] = i*N + left;
		c+=1;
	}
	if ((topn*N +jn) != (i*N+j)) {
		nn[c]=topn*N + jn;
		c+=1;
	}
	if ((bottomn*N +jn) != (i*N+j)) {
		nn[c]=bottomn*N  + jn;
		c+=1;
	}
	if ((in*N +rightn) != (i*N+j)) {
		nn[c]= in*N + rightn;
		c+=1;
	}
	if ((in*N +leftn) != (i*N+j)) {
		nn[c] = in*N + leftn;
		c+=1;
	}

	float test =rand()/(float)RAND_MAX ;

	if (test <=(0.1666)) neighbor_of_pair= nn[0];
	else if ( test <= (2*0.1666)) neighbor_of_pair= nn[1];
	else if ( test <= (3*0.1666)) neighbor_of_pair= nn[2];
	else if ( test <= (4*0.1666)) neighbor_of_pair= nn[3];
	else if ( test <= (5*0.1666)) neighbor_of_pair= nn[4];
	else neighbor_of_pair = nn[5];


return neighbor_of_pair;

}

////////////// main function //////////////////////////////////
int main(){

	srand(time(NULL)); //uses time based seed - since time will always be different, seed will too
	int x,l,t,i,j,z,qvec,qy;
	float p[p_range],q[q_range]; //=0.95; //p is an array of length  = 'p_range'

	for (qvec=0;qvec<q_range;++qvec)
	q[qvec]=qvec/(float)q_range;

	float* den= new float[rep*p_range]; //remember * makes pointer and here den is a matrix of float type entities and the coloums and 'p' values and rows are replicates
	float* av_den= new float[p_range];
	int* neighbor = new int[2];
	//int* neighbor_pair = new int[2];

	//p[0] = 0;
	//for (qvec=0;i<qvec_range;++qvec)
	//q[qvec]=qvec/(float)q_range
	for(i=0;i<p_range;++i)
		p[i]= i/(float)p_range;

	int*A= new int[N*N]; //A matrix of N by N size
	//int*A1= new int[N*N];   // another matrix for synchronous update
	cout<<q<<endl; //syntax for output // endl=end line

for(qy=0000;qy<10000;qy=qy+9200){ 
	for(x=99000;x>0; x=x-10000){    // each loop will calculate stationary density at p[x], x-- = x-1, you can calculate final density only for a subset of p values… you specify those p values this way.
		for(l=0;l<rep;++l){

			create_random_matrix(A,0.5);    //creates random matrix with 0.5 initial density. this must be changed to very high and very low values to get upperbranch and lower branch phase diagram for high values of q

			for(t=0;t<T;t++){ //thus the loop it runs T times

				for(z=0;z<N*N ; ++z){                // so that each site gets selected once on an average

					i = rand()%N;           // selecting one random site. It'll be some random number from 0 t0 N-1
					j = rand()%N;

					float test = rand()/(float)RAND_MAX;
					float test1 = rand()/(float)RAND_MAX;

					if (A[i*N+j]==1){     //if the site is occupied, same as 'i,j' element

						select_neighbor_of_site(i, j ,neighbor);    //look for a neighbor
						int in = neighbor[0] , jn = neighbor[1];

						if (A[in*N +jn]==0) {                     //if neighbor is empty
							if (test < p[x])
								A[in*N+jn]=1;                 //regular cp
							else A[i*N+j]=0;
						}

						else {
							if (test < q[qy]){

								int neighbor_of_pair=select_neighbor_of_pair (in, jn, i, j);  //look for the neighbor of pair
								A[neighbor_of_pair]=1;
							}
							else if (test1 < 1-p[x] ) // this is probability (1-q)(1-p).. yes?
								A[i*N+j]=0;
						}


					}


				}

}
den[l*p_range+x]= density(A);  //l is the index of the replicates
			cout<<p[x]<<"\t"<<den[l*p_range+x]<<"\n";

			ofstream outdata; // outdata is like cin
			outdata.open("tcp_q"+ std::to_string(q[qy]) +"_PD.dat",ios::app); // opens the file
			/*if( !outdata ) { // file couldn't be opened
			cerr << "Error: file could not be opened" << endl;
			exit(1);
			} */

			outdata<<den[l*p_range+x]<<"\n";
			outdata.close();

//============================saving data in a file===============================//
			ofstream spatial_structure_fout;

			spatial_structure_fout.open("tcp_q"+ std::to_string(q[qy]) +"_spatial_data_PD.dat",ios::app);

			for(i=0;i<N;++i){
				for(j=0; j<N ;++j){
					spatial_structure_fout<< A[i*N+j]<< endl;

				}

			}
			spatial_structure_fout.close();

	}
	}
} 

	delete [] A;
	//delete [] A1;
	delete [] den;
	delete [] av_den;
	delete [] neighbor;
	//delete [] neighbor_pair;
	return 0;
}
