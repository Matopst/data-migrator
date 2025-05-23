#!/bin/sh

set -e

echo "🔍 Starting PostgreSQL data migration validation..."

echo ""
echo "📦 Step 1: Directory size comparison"
echo "------------------------------------"
du -sh /mnt/old
du -sh /mnt/new

echo ""
echo "📄 Step 2: File count comparison"
echo "--------------------------------"
count_old=$(find /mnt/old | wc -l)
count_new=$(find /mnt/new | wc -l)
echo "Old: $count_old files"
echo "New: $count_new files"

if [ "$count_old" -ne "$count_new" ]; then
  echo "❌ Mismatch in file count!"
else
  echo "✅ File count matches"
fi

echo ""
echo "🧪 Step 3: rsync dry run for content differences"
echo "------------------------------------------------"
rsync_output=$(rsync -aAXnv --delete /mnt/old/ /mnt/new/)

if [ -z "$rsync_output" ]; then
  echo "✅ No differences found via rsync dry-run"
else
  echo "❌ Differences detected:"
  echo "$rsync_output"
fi

echo ""
echo "✅ Validation complete. Review output above before switching PVCs."