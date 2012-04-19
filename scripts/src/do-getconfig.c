#include <string.h>
#include <stdio.h>
#include <stdlib.h>
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
  puts("Search is performed using the variable DO_CONFIG_PATH which is a list");
  puts("of paths separated by ':'. If the variable is empty or not set, look");
  puts("in:");
  puts("");
  puts("  - DO_CONFIG_HOME if set and not empty (unique path)");
  puts("  - DO_CONFIG_DIRS if set and not empty (directory list)");
  puts("  - XDG_CONFIG_HOME or HOME/.config");
  puts("  - XDG_CONFIG_DIRS or /etc/xdg");
  puts("  - /etc");
  puts("  - XDG_DATA_HOME/defaultconfig or HOME/.local/share/defaultconfig");
  puts("  - XDG_DATA_DIRS/defaultconfig");
  puts("  - /usr/local/share/defaultconfig (also a default for XDG_DATA_DIRS)");
  puts("  - /usr/share/defaultconfig       (also a default for XDG_DATA_DIRS)");
  puts("");
  puts("For each directory, the following file name is searched:");
  puts("  DIR/UNIXNAME/FILENAME");
}

int file_exists(const char* dir, const char* dirext, const char* unixname, const char* filename) {
  int len = 16;
  len += strlen(dir);
  len += strlen(unixname);
  len += strlen(filename);
  if(dirext) len += strlen(dirext);
  char path[len];
  if(dirext) {
    snprintf(path, len, "%s/%s/%s/%s", dir, dirext, unixname, filename);
  } else {
    snprintf(path, len, "%s/%s/%s", dir, unixname, filename);
  }
  struct stat buf;
  int res = stat(path, &buf);
  if (res != -1) {
    puts(path);
    return 1;
  } else {
    return 0;
  };
}

int search_directories(const char* dirs, const char* dirext, const char* unixname, const char* filename) {
  int first = 0;
  int i = 0;
  int max = strlen(dirs);
  if(!max) return 0;
  char dir[max];
  int len;
  while (i <= max) {
    if(dirs[i] == ':' || dirs[i] == 0) {
      len = i - first;
      if(len > 0) {
        memcpy(dir, &dirs[first], len);
        dir[len] = 0;
        /* printf("%d %s\n", len, dir); */
        if(file_exists(dir, dirext, unixname, filename)) return 1;
      }
      first = i + 1;
    }
    i++;
  }
  return 0;
}

int main(int argc, char** argv) {
  int i = 1;
  const char *unixname, *filename;
  const char *do_config_path, *do_config_home, *do_config_dirs, *home;
  const char *xdg_config_home, *xdg_config_dirs, *xdg_data_home, *xdg_data_dirs;
  const char *defaultconfig = "defaultconfig";
  if(argc == i + 2) {
    unixname = argv[i++];
    filename = argv[i++];
    do_config_path  = getenv("DO_CONFIG_PATH");
    do_config_home  = getenv("DO_CONFIG_HOME");
    do_config_dirs  = getenv("DO_CONFIG_DIRS");
    xdg_config_home = getenv("XDG_CONFIG_HOME");
    xdg_config_dirs = getenv("XDG_CONFIG_DIRS");
    home            = getenv("HOME");
    xdg_data_home   = getenv("XDG_DATA_HOME");
    xdg_data_dirs   = getenv("XDG_DATA_DIRS");
    if(do_config_path && *do_config_path) {
      return !search_directories(do_config_path, 0, unixname, filename);
    } else {
      if(do_config_home && *do_config_home) {
        if(file_exists(do_config_home, 0, unixname, filename)) return 0;
      }
      if(do_config_dirs && *do_config_dirs) {
        if(search_directories(do_config_dirs, 0, unixname, filename)) return 0;
      }
      if(xdg_config_home && *xdg_config_home) {
        if(file_exists(xdg_config_home, 0, unixname, filename)) return 0;
      } else if(home && *home) {
        int len = strlen(home) + 16;
        char dir[len];
        snprintf(dir, len, "%s/.config", home);
        if(file_exists(dir, 0, unixname, filename)) return 0;
      }
      if(xdg_config_dirs && *xdg_config_dirs) {
        if(search_directories(xdg_config_dirs, 0, unixname, filename)) return 0;
      } else {
        if(file_exists("/etc/xdg", 0, unixname, filename)) return 0;
      }
      if(file_exists("/etc", 0, unixname, filename)) return 0;
      if(xdg_data_home && *xdg_data_home) {
        if(file_exists(xdg_data_home, defaultconfig, unixname, filename)) return 0;
      } else if(home && *home) {
        int len = strlen(home) + 32;
        char dir[len];
        snprintf(dir, len, "%s/.local/share", home);
        if(file_exists(dir, defaultconfig, unixname, filename)) return 0;
      }
      if(xdg_data_dirs && *xdg_data_dirs) {
        if(search_directories(xdg_data_dirs, defaultconfig, unixname, filename)) return 0;
      }
      if(file_exists("/usr/local/share", defaultconfig, unixname, filename)) return 0;
      if(file_exists("/usr/share", defaultconfig, unixname, filename)) return 0;
    }
  } else {
    help();
  }
  return 1;
}
