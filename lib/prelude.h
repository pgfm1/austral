/* --- BEGIN prelude.h --- */
#include <stdint.h>
#include <stddef.h>

/*
 * Austral types
 */

typedef unsigned char  au_unit_t;
typedef unsigned char  au_bool_t;
typedef unsigned char  au_nat8_t;
typedef signed   char  au_int8_t;
typedef unsigned short au_nat16_t;
typedef signed   short au_int16_t;
typedef unsigned int   au_nat32_t;
typedef signed   int   au_int32_t;
typedef unsigned long  au_nat64_t;
typedef signed   long  au_int64_t;
typedef size_t         au_index_t;
typedef void*          au_fnptr_t;
typedef unsigned char  au_region_t;

#define nil   0
#define false 0
#define true  1

/*
 * A little hack
 */

#define AU_STORE(ptr, val) (*(ptr) = (val), nil)

/*
 * Pervasive
 */

typedef struct {
  void*  data;
  size_t size;
} au_array_t;

extern void* au_index_array(au_array_t array, au_index_t index, au_index_t elem_size);

extern au_array_t au_make_array_from_string(const char* data, size_t size);

extern au_unit_t au_abort(au_array_t message);

extern au_unit_t au_printf(const char* format, ...);

/*
 * Memory functions
 */

extern void* au_calloc(size_t size, size_t count);

extern void* au_realloc(void* ptr, size_t count);

extern void* au_memmove(void* destination, void* source, size_t count);

extern void* au_memcpy(void* destination, void* source, size_t count);

extern au_unit_t au_free(void* ptr);

/*
 * CLI functions
 */

void au_store_cli_args(int argc, char** argv);

size_t au_get_argc();

au_array_t au_get_nth_arg(size_t n);

/* --- END prelude.h --- */