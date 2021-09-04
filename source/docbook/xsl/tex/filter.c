/*
 Copyright ©  2005-2014  Nilgün Belma Bugüner <nilgun@belgeler.gen.tr>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
*/


  /* Bu dosyada uzun uzadıya hatalar elde edilmeye çalışılmamıştır.
   * XML dosyaları TeX dosyalarına dönüştürürken, tali
   * uygulamalarla elde edilemeyen bazı özel durumları elde edebilmek
   * amacıyla bu kod geliştirilmiştir.
   * Bu bir kullanıcı uygulaması değildir.
   * Lütfen komut satırını doğru yazın ve amacı dışında kullanmayın...
   */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <string.h>
#include <signal.h>
#include <zlib.h>

void *
xmalloc (size_t size)
{
  register void *value = malloc (size);
  if (value == 0) {
    fprintf (stderr, "xmalloc: request for %u bytes failed.\n", size);
    abort ();
  }
  return value;
}
/* ========================================================= */
char *
load_file(const char *name, size_t size)
{
  char *buffer;
  gzFile *f;
  int ret;

  f = gzopen(name, "r");
  if (!f) {
    fprintf(stderr, "xsl2tex:load_file: cannot open '%s'.\n", name);
    exit(1);
  }
  if (size == 0) size = 32 * 1024;
  size += 1024;

  while (1) {
    buffer = alloca(size + 4);
    ret = gzread(f, buffer, size);
    if (ret == -1) {
      fprintf(stderr, "xsl2tex:load_file: read error in '%s'.\n", name);
      exit(1);
    }
    if (ret < size) break;
    //free(buffer);
    size *= 2;
    gzseek(f, 0, SEEK_SET);
  }
  gzclose(f);
  buffer[ret] = '\0';

  return buffer;
}

/* ================================================================= */
void
lastproc (char *buf)
{
  char *src, *tgt, *buf2, *t;
  int len, flag;

  len = strlen(buf);
  buf2 = xmalloc(len + 32768); //dosya küçük olunca hesap tutmayabiliyor.
  memset (buf2, 0, len + 32768);
  src = buf;
  tgt = buf2;
  while (*src) {
    if ((strncmp(src, "<scrn>", 6) == 0) ||
        (strncmp(src, "<scrd>", 6) == 0) ||
        (strncmp(src, "<verb>", 6) == 0)) {
      if (strncmp(src, "<scrn>", 6) == 0) {
        strncpy(tgt, "\\scline{", 8);
      } else if (strncmp(src, "<scrd>", 6) == 0) {
        strncpy(tgt, "\\scnline{", 9);
        ++tgt;
      } else {
        strncpy(tgt, "\\ltline{", 8);
      }
      src += 6; tgt += 8;
      while (1) {
        if ((strncmp(src, "</scrn>", 7) == 0) ||
            (strncmp(src, "</scrd>", 7) == 0) ||
            (strncmp(src, "</verb>", 7) == 0)) {
           strncpy(tgt, "}\n", 2);
           src += 6; ++tgt;
          break;
        } else if (*src == ' ') {
          *tgt = '~';
        } else if (*src == '!') {
          strncpy(tgt, "\\strut!", 7);
           tgt += 6;
        } else if (*src == ':') {
          strncpy(tgt, "\\strut:", 7);
           tgt += 6;
        } else if (*src == '=') {
          strncpy(tgt, "\\strut=", 7);
           tgt += 6;
        } else if (strncmp(src, "<i/>", 4) == 0) {
           strncpy(tgt, "\\strut--", 8);
           src += 3; tgt += 7;
        } else {
          *tgt = *src;
        }
        ++src; ++tgt;
      }
    } else if (*src == '\n') {
      flag = 1; --src; if (*src == '{') flag = 0;
      ++src; ++src;
      if (*src == '\\') {
        --src;
        *tgt = *src;
      } else if (*src == ' '){
          while (1) {
            ++src;
            if ((*src != ' ') && (strncmp(src, "\n ", 2) != 0) && (strncmp(src, "\n\n", 2) != 0)) {
              if (flag) {
                *tgt = ' ';
                ++tgt;
              }
              *tgt = *src;
              break;
            }
          }
      } else {
        --src;
        if (flag) {
          *tgt = ' ';
        } else {
          --tgt;
        }
      }
    } else {
      *tgt = *src;
    }
    ++src; ++tgt;
  }
  *tgt = '\0';
  //printf("\n%d", strlen(buf2));

  for (t = buf2; *t; t++) {
    if (strncmp(t, "\n ", 3) == 0) {
      t += 2;
    } else if (strncmp(t, " ", 2) == 0) {
      ++t; printf("~");
    } else if (strncmp(t, "¬", 2) == 0) {
      ++t; printf("\\textlogicalnot ");
    } else if (strncmp(t, "<a/>", 4) == 0) {
      t += 3; printf("\\/");
    } else if (strncmp(t, "<b/>", 4) == 0) {
      t += 3; printf("\\%%");
    } else if (*t == '#') { /* <c/> aramasından önce bakılmalı */
      printf("\\#");
    } else if (strncmp(t, "<c/>", 4) == 0) {
      t += 3; printf("\\#");
    } else if (strncmp(t, "<d/><d/>", 8) == 0) {
      t += 7; printf("\\duscore ");
    } else if (strncmp(t, "<d/>", 4) == 0) {
      t += 3; printf("\\_");
    } else if (strncmp(t, "<e/>", 4) == 0) {
      t += 3; printf("\\{");
    } else if (strncmp(t, "<f/>", 4) == 0) {
      t += 3; printf("\\}");
    } else if (*t == '&') { /* <g/> aramasından önce bakılmalı */
      printf("\\&");
    } else if (strncmp(t, "<g/>", 4) == 0) {
      t += 3; printf("\\&");
    } else if (strncmp(t, "<h/>", 4) == 0) {
      t += 3; printf("\\$");
    } else if (strncmp(t, "<i/>", 4) == 0) {
      t += 3; printf("\\strut--");
    } else if (strncmp(t, "<j/>", 4) == 0) {
      t += 3; printf("\\~{}");
    } else if (strncmp(t, "<k/>", 4) == 0) {
      t += 3; printf("\\^");
    } else if (strncmp(t, "<l/>", 4) == 0) {
      t += 3; printf("'");
    } else if (strncmp(t, "<m/>", 4) == 0) {
      t += 3; printf("&");
    } else if (strncmp(t, "<<", 2) == 0) {
      printf("<\\strut ");
    } else if (strncmp(t, ">>", 2) == 0) {
      printf(">\\strut ");
    } else if (strncmp(t, "±", 2) == 0) {
      ++t; printf("\\textplusminus ");
    } else {
      putchar(*t);
    }
  }
  free(buf2);
}

/* ================================================================= */

int
main(int argc, char *argv[])
{
  char *buf;

  setlocale (LC_ALL, "tr_TR.UTF-8");

  if (argc < 3) {
    puts("usage: filter file size > tex_file");
    return 1;
  }

  /* Bu dosyada uzun uzadıya hatalar elde edilmeye çalışılmamıştır.
   * XML dosyaları tex dosyalarına dönüştürürken, tali
   * uygulamalarla elde edilemeyen bazı özel durumları elde edebilmek
   * amacıyla bu kod geliştirilmiştir.
   * Bu bir kullanıcı uygulaması değildir.
   * Lütfen komut satırını doğru yazın ve amacı dışında kullanmayın...
   */
  //printf("%s, %d", argv[1], atoi(argv[2]));
  buf = load_file(argv[1], atoi(argv[2]));
  //printf("\n%d", strlen(buf));
  //puts(buf);
  lastproc(buf);

  return 0;
}
