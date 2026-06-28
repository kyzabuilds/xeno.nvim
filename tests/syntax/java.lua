-- Generic Java sample for pop-in and color-distribution inspection.
-- Covers imports, annotations, records, generics, fields, methods, lambdas,
-- switch expressions, literals, exceptions, and common java.lang references.
return {
  filetype = "java",
  lang = "java",
  code = [[
package dev.xeno.samples;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import static java.util.stream.Collectors.toList;

@FunctionalInterface
interface Formatter<T extends Record> {
  String format(T value);
}

public final class AuditService implements AutoCloseable {
  private static final int MAX_BATCH_SIZE = 128;
  private final Map<String, AuditRecord> cache = new ConcurrentHashMap<>();
  private volatile boolean closed = false;

  public record AuditRecord(String id, Instant createdAt, List<String> tags) {
    public boolean isTagged(String tag) {
      return tags.stream().anyMatch(tag::equalsIgnoreCase);
    }
  }

  public Optional<AuditRecord> find(String id) throws IllegalStateException {
    if (closed) {
      throw new IllegalStateException("service is closed");
    }

    return Optional.ofNullable(cache.get(id));
  }

  public List<String> summarize(List<AuditRecord> records, Formatter<AuditRecord> formatter) {
    return records.stream()
      .filter(record -> record.tags().size() < MAX_BATCH_SIZE)
      .map(record -> switch (record.tags().size()) {
        case 0 -> "empty:" + record.id();
        case 1, 2 -> formatter.format(record);
        default -> String.format("%s:%d", record.id(), record.tags().size());
      })
      .sorted()
      .collect(toList());
  }

  @Override
  public void close() {
    this.closed = true;
    cache.clear();
  }
}
]],
}
