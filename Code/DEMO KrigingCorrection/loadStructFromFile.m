function result = loadStructFromFile(fileName) 

% load with no structure

tmp = load(fileName);
tmpfield = fieldnames(tmp);
result = tmp.(tmpfield{1}); 