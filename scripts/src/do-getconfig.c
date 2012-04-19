#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

static void help() {
  puts("do-getconfig UNIXNAME FILENAME");
  puts("");
  puts("Print on the standard output the filename FILENAME as found in a");
  puts("configuration directory for the program UNIXNAME. Exit with an error");
  puts("status if the file is not found.");
  puts("");
  puts("Search is performed in the following order:");
  puts("");
  puts("  - DO_CONFIG_PATH - list of paths separated by ':'");
  puts("    (if the variable is set, then skip the following paths)");
  puts("  - XDG_CONFIG_HOME or HOME/.config");
  puts("  - /etc");
  puts("  - XDG_DATA_DIRS or XDG_DATA_HOME or HOME/.local/share ");
  puts("");
  puts("For each directory, the following file name is searched:");
  puts("  DIR/UNIXNAME/FILENAME");
}

int file_exists(const char* dir, const char* unixname, const char* filename) {
  int dir_l = strlen(dir);
  int uni_l = strlen(unixname);
  int fil_l = strlen(filename);
  int pat_l = dir_l + uni_l + fil_l + 3;
  char path[pat_l];
  snprintf(path, pat_l, "%s/%s/%s\0", dir, unixname, filename);
  struct stat buf;
  int res = stat(path, &buf);
  if (res != -1) {
    puts(path);
    return 1;
  } else {
    return 0;
  };
}

int main(int argc, char** argv) {
  int i = 1;
  const char *unixname, *filename;
  if(argc == i + 2) {
    unixname = argv[i++];
    filename = argv[i++];
    if(file_exists("/etc", unixname, filename)) return 0;
  } else {
    help();
  }
  return 1;
}
