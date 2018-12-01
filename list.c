#include "assignment3.h"
#include <stdio.h>
#include <stdlib.h>

// NOTE: arrays only used in the createHBlist function

static struct HBnode *addHBnode(struct HBnode *list, int n) {
  struct HBnode *new_HB;
  new_HB = malloc(sizeof(struct HBnode));
  new_HB->key = n;
  new_HB->next = list;
  new_HB->bottom = NULL;
  return new_HB;
}

static struct SLnode *addSLnode(struct SLnode *firstSL, int n) {
  struct SLnode *new_SL;
  new_SL = malloc(sizeof(struct SLnode));
  new_SL->key = n;
  new_SL->next = firstSL;
  return new_SL;
}

static SLnodePtr Insert(SLnodePtr first, int insert) {
  if (first == NULL) {
    first = malloc(sizeof(struct SLnode));
    first->key = insert;
    first->next = NULL;
    return first;
  }
  SLnodePtr new = malloc(sizeof(struct SLnode));
  new->key = insert;
  new->next = NULL;
  if (insert < first->key) {
    new->next = first;
    return new;
  }
  SLnodePtr temp = first;
  SLnodePtr temp2;
  while (temp->key <= insert && temp->key) {
    temp2 = temp;
    if (temp->next == NULL) {
      new->next = temp->next;
      temp->next = new;
      return first;
    }
    temp = temp->next;
  }
  new->next = temp;
  temp2->next = new;
  return first;
}

HBnodePtr createHBlist(int n, int m) {
  HBnodePtr firstHB = NULL;
  SLnodePtr firstSL = NULL;
  if (n == 0)
    return NULL;
  int i, j, HBnodes, SLnodes;

  int *HBarray;
  HBarray = (int *)malloc(n * sizeof(int));

  for (i = 0; i < n; i++) {
    HBnodes = rand() % (1001);
    HBarray[i] = HBnodes;
  }
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      if (HBarray[i] > HBarray[j]) {
        int temp = HBarray[i];
        HBarray[i] = HBarray[j];
        HBarray[j] = temp;
      }
    }
  }

  for (i = 0; i < n; i++) {
    firstHB = addHBnode(firstHB, HBarray[i]);
    if (m) {
      int range = rand() % (m + 1);
      for (j = 0; j < range; j++) {
        SLnodes = rand() % (1001) + 1000;
        firstSL = Insert(firstSL, SLnodes);
      }
    }
    firstHB->bottom = firstSL;
    firstSL = NULL;
  }
  free(HBarray);
  return firstHB;
}

static int count(const HBnodePtr L) {
  int n = 1;
  HBnodePtr temp = L->bottom;
  printf("\n");
  printf("%d   ", L->key);
  if (temp == NULL) {
    printf("\n");
    return n;
  }
  while (temp->next) {
    n++;
    printf("%d   ", temp->key);
    temp = temp->next;
  }
  printf("%d", temp->key);
  printf("\n");
  n++;
  return n;
}

void printHBlist(const HBnodePtr L) {
  int n = 0;
  HBnodePtr temp2 = L;
  while (temp2->next) {
    n = n + count(temp2);
    temp2 = temp2->next;
  }
  n = n + count(temp2);
}

void printSLlist(const SLnodePtr L) {
  SLnodePtr temp = L;
  while (temp->next) {
    printf("%d  ", temp->key);
    temp = temp->next;
  }
  printf("%d  ", temp->key);
  printf("\n");
}

static SLnodePtr merge(HBnodePtr L, SLnodePtr first) {
  int ref;
  if (L == NULL)
    return first;
  HBnodePtr temp = L->bottom;
  if (temp == NULL) {
    ref = L->key;
    first = Insert(first, ref);
    return first;
  }
  ref = L->key;
  first = Insert(first, ref);
  while (temp->next) {
    int ref = temp->key;
    first = Insert(first, ref);
    temp = temp->next;
  }
  ref = temp->key;
  first = Insert(first, ref);
  return first;
}

SLnodePtr flattenList(const HBnodePtr L) {
  HBnodePtr temp = L;
  SLnodePtr first = NULL;
  if (L == NULL) {
    return first;
  }
  while (temp->next) {
    first = merge(temp, first);
    temp = temp->next;
  }
  first = merge(temp, first);
  return first;
}

void freeHBlist(const HBnodePtr L) {
  HBnodePtr h = L;
  HBnodePtr A;
  HBnodePtr B;
  if (L == NULL)
    return;
  while (h->next) {
    A = h;
    h = h->next;
    B = A;
    A = A->bottom;
    free(B);
    if (A) {
      while (A->next) {
        B = A;
        A = A->next;
        free(B);
      }
    }
    free(A);
  }
  A = h;
  h = h->bottom;
  free(A);
  if (h) {
    while (h->next) {
      if (h == NULL)
        break;
      A = h;
      h = h->next;
      free(A);
    }
  }
  free(h);
}

void freeSLlist(const SLnodePtr L) {
  SLnodePtr p = L;
  SLnodePtr temp;
  while (p->next) {
    temp = p;
    p = p->next;
    free(temp);
  }
  free(p);
}