with open(out_file, "w") as fp:
    fp.write("[")
    
    for col in range(img.shape[1]):
        process_column(img, img.shape[0] - 1, col, fp)
    
    fp.write('{"p":[0,0,0],"s":[10,10,10]}]')

print(
    "\n"
    "%s\n"
    "Object count:      %d\n"
    "Objects saved:     %d\n"
    "Compression ratio: %lf"
    "\n"
    "You'll see a 10x10 cube in the asset. This is to make sure it can be imported properly."
    % (underscore_pad("Completed", 80), object_count, pixel_count - object_count, pixel_count / object_count)
)
