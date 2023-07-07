import sys

d_trig = False
f_trig = False
o_trig = False

i_trig = False

file_name = ''
path = ''
outfile_name = ''

def consist_list(file):
    f = open(file, "r")
    data = f.read()
    f.close()

    data = data.split('\n')[:-1]
    if d_trig:
        print(data)
    return data

if __name__ == "__main__":
    for i in sys.argv:
        if i == '-d':
            d_trig = True
        elif i == '-p':
            f_trig = True
        elif f_trig == True:
            file_name = i
            f_trig = False
        elif i == '-o':
            o_trig = True
        elif o_trig == True:
            outfile_name = i
            o_trig = False
        elif i == '-i':
            i_trig = True

    if len(file_name) == 0:
        print('Enter the Path list file name behind -p.')
        exit(-1)

    contents = consist_list(file_name)

    if i_trig == True:
        out_file = open(outfile_name.split('.')[0] + '_ID.txt', "w")
        for file in contents:
            f = open(file + '.txt', "r")
            for line in f:
                out_file.write(line[:-1] + ' ' + file + '\n')
    else:
        out_file = open(outfile_name, "w")
        for file in contents:
            f = open(file + '.txt', "r")
            for line in f:
                out_file.write(line[:-1] + '\n')
    f.close()
    out_file.close()
