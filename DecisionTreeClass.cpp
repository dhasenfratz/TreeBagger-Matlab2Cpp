/*
The MIT License (MIT)

Copyright (c) <2014> <Paul Kendrick>
Copyright (c) <2016> <David Hasenfratz>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#include "DecisionTreeClass.hpp"


int DTree::decisionTreeFun(float *x) {
    
    int out[NO_BAGS];
    for (int bagi = 0; bagi < NO_BAGS; bagi++)
        out[bagi] = 0;

    int j, bagi, bi, ni;
    for ( bagi = 0; bagi < NO_BAGS; bagi++) {
        out[bagi] = 0;
        for (bi = 0; bi < NO_BRANCHES[bagi]; bi++) {
            result[bagi][bi] = 1;
            for (ni = 0; ni < BRANCH_LENGTHS[bagi][bi]; ni++) {
                test[bagi][bi][ni] = 0;
                if (BRANCH_LOGIC[bagi][bi][ni] == 1) {
                    if (x[BRANCH_VECTOR_INDEX[bagi][bi][ni] - 1] < BRANCH_VALUES[bagi][bi][ni]) {
                        test[bagi][bi][ni] = 1;
                    }
                }

                if (BRANCH_LOGIC[bagi][bi][ni] == 0) {
                    if (x[BRANCH_VECTOR_INDEX[bagi][bi][ni] - 1] >= BRANCH_VALUES[bagi][bi][ni]) {
                        test[bagi][bi][ni] = 1;
                    }
                }
                result[bagi][bi] = result[bagi][bi] * test[bagi][bi][ni];
            }
        }
        for ( j = 0; j < NO_BRANCHES[bagi]; j++) {
            if (result[bagi][j] == 1) {
                out[bagi] = CLASS_LABELS[bagi][j];
            }
        }
    }
   
    // now provide the class estimate that is most popular
    int  count[NO_CLASSES];
    int ClassTest[NO_CLASSES];
    
    for (int j = 0; j < NO_CLASSES; j++)
        ClassTest[j] = j;
    for (int i = 0; i < NO_CLASSES; i++)
        count[i] = 0;

    for (int i = 0; i < NO_BAGS; i++) {
        for (int j = 0; j < NO_CLASSES; j++) {
            if (out[i] == ClassTest[j])
                count[j] = count[j] + 1;

        }
    }

    int output = 0;
    int max = count[0];
    int storeMaxclasses[NO_CLASSES];
    for (int j = 1; j < NO_CLASSES; j++) {
        if (count[j] > max) {
            output = j;
            max = count[j];
        }
    }
    
    int countave=0;
    for (int j = 1; j < NO_CLASSES; j++) {
        if (count[j] == max) {
            storeMaxclasses[countave]=j;
            countave++;
        }
    }
    if (countave == 1) {
    } else if (countave ==0) {
    }
    else if (countave % 2 ==1) {
        int in=(countave-1)/2;
        output=storeMaxclasses[in+1];
    }
    else if (countave % 2 ==0) {
        int in=(countave/2);
        in=in - rand() % 2;
        output=storeMaxclasses[in];
    }
    
    return output;
}
