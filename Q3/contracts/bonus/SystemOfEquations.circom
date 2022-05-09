pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here

    // matrix multiplication, [n X 1]matrix * [n X 1]matrix
    component mMul = matMul(n,n,1);

    // storage products of the matrix
    for (var i = 0; i < n; i++) {
        mMul.b[i][0] <== x[i];

        for (var j = 0; j < n; j++) {
            mMul.a[i][j] <== A[i][j];
        }
    }

    // for comparation
    component mIsEqual[n];
    component isEqual = IsEqual();
    component mElemSum = matElemSum(n, 1);

    // compare rows
    for (var i = 0; i < n; i++) {
        mIsEqual[i] = IsEqual();
        mIsEqual[i].in[0] <== b[i];
        mIsEqual[i].in[1] <== mMul.out[i][0];

        mElemSum.a[i][0] <== mIsEqual[i].out;
    }

    isEqual.in[0] <== n;
    isEqual.in[1] <== mElemSum.out;

    out <== isEqual.out;
}

component main {public [A, b]} = SystemOfEquations(3);