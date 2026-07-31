-- Generic Rust sample for pop-in and color-distribution inspection.
-- Covers attributes/derives, structs, enums, traits, impl blocks, generics,
-- lifetimes, closures, pattern matching, async/await, macros, and literals.
return {
  filetype = "rust",
  lang = "rust",
  code = [[
use std::collections::HashMap;
use std::fmt;
use std::sync::{Arc, Mutex};

/// A unique identifier backed by a 64-bit integer.
/// TODO: consider switching to UUID once `uuid` stabilises.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct EventId(u64);

#[derive(Debug, Clone)]
pub enum EventKind {
  Created,
  Updated { field: String },
  Deleted,
}

pub trait Summarise {
  fn summary(&self) -> String;
  fn is_empty(&self) -> bool {
    false
  }
}

#[derive(Debug)]
pub struct Event {
  pub id: EventId,
  pub kind: EventKind,
  pub payload: Vec<u8>,
  pub retries: u32,
}

impl fmt::Display for EventId {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "evt:{}", self.0)
  }
}

impl Summarise for Event {
  fn summary(&self) -> String {
    format!("{} retries={}", self.id, self.retries)
  }
}

static MAX_RETRIES: u32 = 5;
const BATCH_SIZE: usize = 128;

pub struct Registry<'a> {
  store: HashMap<u64, Event>,
  label: &'a str,
}

impl<'a> Registry<'a> {
  pub fn new(label: &'a str) -> Self {
    Registry {
      store: HashMap::new(),
      label,
    }
  }

  pub fn insert(&mut self, event: Event) -> bool {
    let id = event.id.0;
    self.store.insert(id, event).is_none()
  }

  pub fn find(&self, id: u64) -> Option<&Event> {
    self.store.get(&id)
  }

  pub async fn flush_async(&mut self) -> Result<usize, String> {
    let count = self.store.len();
    self.store.clear();
    Ok(count)
  }

  pub fn summarise_all(&self) -> Vec<String> {
    self.store
      .values()
      .filter(|e| e.retries < MAX_RETRIES)
      .map(|e| e.summary())
      .collect()
  }
}

fn process(events: &[Event], shared: Arc<Mutex<Vec<String>>>) {
  for event in events {
    let summary = match &event.kind {
      EventKind::Created => format!("created:{}", event.id),
      EventKind::Updated { field } => format!("updated:{}:{}", event.id, field),
      EventKind::Deleted => String::from("deleted"),
    };

    if event.retries > 0 {
      let mut guard = shared.lock().unwrap();
      guard.push(summary);
    }
  }
}

fn fibonacci(n: u64) -> u64 {
  let mut a: u64 = 0;
  let mut b: u64 = 1;
  let mut i: u64 = 0;
  loop {
    if i >= n {
      break a;
    }
    let tmp = a + b;
    a = b;
    b = tmp;
    i += 1;
  }
}

fn main() {
  let mut registry = Registry::new("primary");
  let event = Event {
    id: EventId(42),
    kind: EventKind::Created,
    payload: vec![0x01, 0x02, 0xFF],
    retries: 0,
  };
  assert!(registry.insert(event), "duplicate insert");
  let found = registry.find(42);
  let ratio: f64 = 1.618_033_988;
  let flag = true;
  println!("ratio={} flag={} fib={}", ratio, flag, fibonacci(10));
  // single-line comment
  /* block comment */
}
]],
}
