% The MIT License (MIT)
%
% Copyright (c) <2014> <Paul Kendrick>
% Copyright (c) <2016> <David Hasenfratz>
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

function []=extractDecTreeStruct(b,classesunique,treebag,bags)
% 	This function takes a treebagger class, or decision tree class, and outputs a text file with all
%	The information required to export the treebagger / classification functions
%   inputs
%	b : Treebagg class structure, or or classification tree structure
%	classesunique : list of unique class labels (numerical)
%	treebag : 0 for classification tree, 1 for treebagger
%	bags : number of bags

uniqueclasses=sort(classesunique,'ascend');
% meas,species
clear class class_out
for bagi=1:bags
    if treebag==1
            [T] = evalc('view(b.Trees{bagi})');    
    else
        [T] = evalc('view(b)');    
    end

C=textscan(T,'%s','Delimiter','\n');
clear C1;
for i=3:length(C{1})-1
    
    C1{i-2}=C{1}{i};
end


i=1;
TreeMat=[];
clear TreeDecisions 
Cline=textscan(C1{i},'%s','Delimiter',' ');
Cline=Cline{1};
n=1;%str2num(Cline{7})
% first find every path through tree   
%%  Locate ends of branches
clear ends
for i=1:length(C1)
ends(i)=length(strfind(C1{i},'class'))>0;
end
branches=sum(ends); %branches


% log the node paths for each non-ned of branch path 

I=find(ends==0);
clear nodeVecI nodeVecI nodeLogicVal nodepaths

for i=1:length(I)
        Ctmp=textscan(C1{I(i)},'%s','Delimiter',' ');
    Ctmp=Ctmp{1};
nodepaths(I(i),1)=str2num(Ctmp{7});
nodepaths(I(i),2)=str2num(Ctmp{12});
nodeLogic{I(i),1}=(Ctmp{4});
nodeLogic{I(i),2}=(Ctmp{9});

tt=textscan(Ctmp{4},'%*c%*n%*c%n');
nodeLogicVal(I(i),1)=tt{1};


tt=textscan(Ctmp{4},'%*c%n%*c%*n');
nodeVecI(I(i),1)=(tt{1});


end
%%
clear storeBranchTmpVecI storeBranchTmpVal storeBranchTmpL storeBranchLength
I=find(ends==1);
for i=1:sum(ends)
    ClineEnd=textscan(C1{I(i)},'%s','Delimiter',' ');
    ClineEnd=ClineEnd{1};
    Class{i}=ClineEnd{end};
    node_next=str2num(ClineEnd{1});
    %now traceback to start recording logical decisions as we go
    BranchTmp=[];
    BranchTmpL=[];
    BranchTmpVecI=[];
    BranchTmpVal=[];
    foundStart=0;
    nodes=[];
    
    
    
    while foundStart==0
        
         n1=find(nodepaths==node_next);[n,J] = ind2sub(size(nodepaths),n1);
        
        
        nodes=[nodes n];
        BranchTmpL=[BranchTmpL J==1];
        BranchTmpVecI=[BranchTmpVecI nodeVecI(n)];
        BranchTmpVal=[BranchTmpVal nodeLogicVal(n)];
        if (n==1)
            foundStart=1;
        end

        ClineTmp=textscan(C1{n},'%s','Delimiter',' ');
        ClineTmp=ClineTmp{1};
        node_next=str2num(ClineTmp{1});
    end
    N=length(BranchTmpVecI);
    storeBranchTmpVecI(i,1:N)=fliplr(BranchTmpVecI);
    storeBranchTmpVal(i,1:N)=fliplr(BranchTmpVal);
    storeBranchTmpL(i,1:N)=fliplr(BranchTmpL);
    storeBranchLength(i)=length(BranchTmpVal);
    
end
storeBranchTmpVal(storeBranchTmpVecI==0)=nan;
storeBranchTmpL(storeBranchTmpVecI==0)=nan; % 1 is less than  ... 0 is greater or equal to
storeBranchTmpVecI(storeBranchTmpVecI==0)=nan;
%% % Decision tree code

 all_bags{bagi} = bags;
 all_branches{bagi} = branches;
 all_storeBranchLength{bagi} = storeBranchLength;
 all_storeBranchTmpL{bagi} = storeBranchTmpL;
 all_storeBranchTmpVal{bagi} = storeBranchTmpVal;
 all_storeBranchTmpVecI{bagi} = storeBranchTmpVecI;
 all_Class{bagi} = Class;

end

fid=fopen('decTreeConstants.h', 'w');

fprintf(fid,'#ifndef DECTREECONSTANTS_h\n');
fprintf(fid,'#define DECTREECONSTANTS_h\n\n');
fprintf(fid,'const int NO_CLASSES = %i;\n', length(uniqueclasses));
fprintf(fid,'const int NO_BAGS = %i;\n', bags);

fprintf(fid,'\nconst int NO_BRANCHES[%i] = {', bags);
for bagi=1:numel(all_bags)
    if bagi < numel(all_bags)
        fprintf(fid,'%i, ', all_branches{bagi});
    else
        fprintf(fid,'%i};\n', all_branches{bagi});
    end
end

fprintf(fid,'\nconst int BRANCH_LENGTHS[%i][%i] = {\n', bags, max(cell2mat(all_branches)));
for bagi=1:numel(all_bags)
    fprintf(fid,'  {');
    for i=1:numel(all_storeBranchLength{bagi})
        if i < numel(all_storeBranchLength{bagi})
            fprintf(fid,'%i, ', all_storeBranchLength{bagi}(i));
        else
            if bagi < numel(all_bags)
                fprintf(fid,'%i},\n', all_storeBranchLength{bagi}(i));
            else
                fprintf(fid,'%i}};\n', all_storeBranchLength{bagi}(i));
            end
        end
    end
end

fprintf(fid,'\nconst int BRANCH_LOGIC[%i][%i][%i] = {\n', bags, max(cell2mat(all_branches)), max(cell2mat(all_storeBranchLength)));
for bagi=1:numel(all_bags)
    fprintf(fid,'  {\n');
    for i=1:numel(all_storeBranchLength{bagi})
        fprintf(fid,'    {');
        for j=1:all_storeBranchLength{bagi}(i)
            if j < all_storeBranchLength{bagi}(i)
                fprintf(fid,'%i, ', all_storeBranchTmpL{bagi}(i,j));
            else
                if i < numel(all_storeBranchLength{bagi})
                    fprintf(fid,'%i},\n', all_storeBranchTmpL{bagi}(i,j));
                else
                    if bagi < numel(all_bags)
                        fprintf(fid,'%i}},\n', all_storeBranchTmpL{bagi}(i,j));
                    else
                        fprintf(fid,'%i}}};\n', all_storeBranchTmpL{bagi}(i,j));
                    end
                end
            end
        end
    end
end

fprintf(fid,'\nconst float BRANCH_VALUES[%i][%i][%i] = {\n', bags, max(cell2mat(all_branches)), max(cell2mat(all_storeBranchLength)));
for bagi=1:numel(all_bags)
    fprintf(fid,'  {\n');
    for i=1:numel(all_storeBranchLength{bagi})
        fprintf(fid,'    {');
        for j=1:all_storeBranchLength{bagi}(i)
            if j < all_storeBranchLength{bagi}(i)
                fprintf(fid,'%f, ', all_storeBranchTmpVal{bagi}(i,j));
            else
                if i < numel(all_storeBranchLength{bagi})
                    fprintf(fid,'%f},\n', all_storeBranchTmpVal{bagi}(i,j));
                else
                    if bagi < numel(all_bags)
                        fprintf(fid,'%f}},\n', all_storeBranchTmpVal{bagi}(i,j));
                    else
                        fprintf(fid,'%f}}};\n', all_storeBranchTmpVal{bagi}(i,j));
                    end
                end
            end
        end
    end
end

fprintf(fid,'\nconst int BRANCH_VECTOR_INDEX[%i][%i][%i] = {\n', bags, max(cell2mat(all_branches)), max(cell2mat(all_storeBranchLength)));
for bagi=1:numel(all_bags)
    fprintf(fid,'  {\n');
    for i=1:numel(all_storeBranchLength{bagi})
        fprintf(fid,'    {');
        for j=1:all_storeBranchLength{bagi}(i)
            if j < all_storeBranchLength{bagi}(i)
                fprintf(fid,'%i, ', all_storeBranchTmpVecI{bagi}(i,j));
            else
                if i < numel(all_storeBranchLength{bagi})
                    fprintf(fid,'%i},\n', all_storeBranchTmpVecI{bagi}(i,j));
                else
                    if bagi < numel(all_bags)
                        fprintf(fid,'%i}},\n', all_storeBranchTmpVecI{bagi}(i,j));
                    else
                        fprintf(fid,'%i}}};\n', all_storeBranchTmpVecI{bagi}(i,j));
                    end
                end
            end
        end
    end
end

fprintf(fid,'\nconst int CLASS_LABELS[%i][%i] = {\n', bags, max(cell2mat(all_branches)));
for bagi=1:numel(all_bags)
    fprintf(fid,'  {');
    for i=1:numel(all_storeBranchLength{bagi})
        if i < numel(all_storeBranchLength{bagi})
            fprintf(fid,'%s, ', cell2mat(all_Class{bagi}(i)));
        else
            if bagi < numel(all_bags)
                fprintf(fid,'%s},\n', cell2mat(all_Class{bagi}(i)));
            else
                fprintf(fid,'%s}};\n', cell2mat(all_Class{bagi}(i)));
            end
        end
    end
end
fprintf(fid,'\n<-- Remove this line after copying -->\n');
fprintf(fid,'// THESE TWO VARIALBES NEED TO BE COPIED TO THE HEADER FILE DecisionTreeClass.hpp\n');
fprintf(fid,'//float test[%i][%i][%i];\n', bags, max(cell2mat(all_branches)), max(cell2mat(all_storeBranchLength)));
fprintf(fid,'//float result[%i][%i];\n', bags, max(cell2mat(all_branches)));
fprintf(fid,'<------------------------------------>\n');

fprintf(fid,'\n#endif\n');
