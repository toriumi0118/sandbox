#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <search.h>

#define MAXLEN 256

int
skip(FILE *fp)
{
    char c;
    int cnt = 0;

    while ((c = fgetc(fp)) != EOF) {
        if (isalpha(c)) {
            ungetc(c, fp);
            return cnt;
        }
        cnt++;
    }

    return EOF;
}

char *
getword(FILE *fp, char *buf, int len)
{
    char c;
    int i = 0;

    c = fgetc(fp);
    if (c == EOF) {
        return NULL;
    }

    while (1) {
        if (!isalpha(c) || c == EOF) {
            ungetc(c, fp);
            buf[i] = '\0';
            skip(fp);
            return buf;
        }

        buf[i] = (char) tolower(c);

        i++;
        if (i >= len) {
            printf("buffer overflow\n");
            return NULL;
        }
        c = fgetc(fp);
    }
}

struct wordcnt {
    char *word;
    int cnt;
};

int wccmp(const void *a, const void *b) {
    struct wordcnt *wc1, *wc2;

    wc1 = (struct wordcnt *) a;
    wc2 = (struct wordcnt *) b;

    return wc2->cnt - wc1->cnt;
}

int
main(int argc, char *argv[])
{
    FILE *fp;
    char *mode, *file;
    char *w;
    char buf[MAXLEN];
    struct wordcnt wordcnt[2048];
    int wcount = 0;
    int i;

    if (argc < 3) {
        printf("Usage: %s [123] inputfile\n", argv[0]);
        return 1;
    }

    mode = argv[1];
    file = argv[2];

    if ((fp = fopen(file, "r")) == NULL) {
        printf("file open error: file=%s\n", file);
        return 1;
    }

    hcreate(4096);

    while (getword(fp, buf, MAXLEN) != NULL) {
        ENTRY item, *ip;
        struct wordcnt *wc = &wordcnt[wcount];

        item.key = buf;
        item.data = &wc->cnt;
        if ((ip = hsearch(item, FIND)) == NULL) {
            int len = strnlen(buf, MAXLEN);
            char *key = (char *) malloc(sizeof (char) * len);

            strncpy(key, buf, MAXLEN);
            item.key = key;
            wc->word = key;
            wc->cnt = 1;

            hsearch(item, ENTER);
            wcount++;
        } else {
            *((int *) ip->data) += 1;
        }
    }

    qsort(wordcnt, wcount, sizeof (struct wordcnt), wccmp);
    for (i = 0; i < wcount; i++) {
        struct wordcnt *wc = &wordcnt[i];
        printf("% 4d: %s\n", wc->cnt, wc->word);
    }

    hdestroy();

    fclose(fp);

    return 0;
}
