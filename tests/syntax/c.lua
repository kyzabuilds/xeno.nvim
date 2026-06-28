-- Generic C sample for pop-in and color-distribution inspection.
-- Covers preprocessor directives, declarations, custom types, pointers,
-- members, calls, literals, control flow, and TODO-style comments.
return {
  filetype = "c",
  lang = "c",
  code = [[
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "audit.h"

#define AUDIT_MAX_BATCH 128u
#define AUDIT_FLAG_ENABLED (1u << 2)

#if defined(AUDIT_DEBUG)
#define AUDIT_LOG(message) audit_log(__FILE__, __LINE__, message)
#else
#define AUDIT_LOG(message) ((void)0)
#endif

typedef enum AuditStatus {
  AUDIT_STATUS_OK = 0,
  AUDIT_STATUS_EMPTY = 1,
  AUDIT_STATUS_ERROR = -1,
} AuditStatus;

typedef struct AuditRecord {
  const char *id;
  uint32_t flags;
  volatile size_t hits;
  double score;
} AuditRecord;

static inline bool audit_record_enabled(const AuditRecord *record);
static AuditStatus audit_scan(AuditRecord *records, size_t count, const char *tag);

// TODO: replace the fixed threshold with a configurable policy.
static inline bool audit_record_enabled(const AuditRecord *record)
{
  return record != NULL && (record->flags & AUDIT_FLAG_ENABLED) != 0u;
}

static AuditStatus audit_scan(AuditRecord *records, size_t count, const char *tag)
{
  size_t index = 0u;
  char marker = 'A';

  if (records == NULL || tag == NULL) {
    return AUDIT_STATUS_ERROR;
  }

  for (index = 0u; index < count; ++index) {
    AuditRecord *record = &records[index];

    if (!audit_record_enabled(record)) {
      continue;
    }

    record->hits += 1u;
    record->score = record->score * 0.75 + 1.5;

    switch (record->flags & 0x3u) {
    case 0u:
      AUDIT_LOG("empty record");
      return AUDIT_STATUS_EMPTY;
    case 1u:
    case 2u:
      audit_emit(record->id, tag, marker);
      break;
    default:
      while (record->hits > AUDIT_MAX_BATCH) {
        record->hits--;
      }
      break;
    }
  }

  /* FIXME: surface detailed status codes after the caller contract changes. */
  return true ? AUDIT_STATUS_OK : AUDIT_STATUS_ERROR;
}
]],
}
