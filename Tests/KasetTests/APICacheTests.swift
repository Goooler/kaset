import XCTest
@testable import Kaset

/// Tests for APICache.
@MainActor
final class APICacheTests: XCTestCase {
    var cache: APICache!

    override func setUp() async throws {
        cache = APICache.shared
        cache.invalidateAll()
    }

    override func tearDown() async throws {
        cache.invalidateAll()
        cache = nil
    }

    func testCacheSetAndGet() {
        let data: [String: Any] = ["key": "value", "number": 42]
        cache.set(key: "test_key", data: data, ttl: 60)

        let retrieved = cache.get(key: "test_key")
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?["key"] as? String, "value")
        XCTAssertEqual(retrieved?["number"] as? Int, 42)
    }

    func testCacheGetNonexistent() {
        let retrieved = cache.get(key: "nonexistent_key")
        XCTAssertNil(retrieved)
    }

    func testCacheInvalidateAll() {
        cache.set(key: "key1", data: ["a": 1], ttl: 60)
        cache.set(key: "key2", data: ["b": 2], ttl: 60)

        XCTAssertNotNil(cache.get(key: "key1"))
        XCTAssertNotNil(cache.get(key: "key2"))

        cache.invalidateAll()

        XCTAssertNil(cache.get(key: "key1"))
        XCTAssertNil(cache.get(key: "key2"))
    }

    func testCacheInvalidateMatchingPrefix() {
        cache.set(key: "home_section1", data: ["a": 1], ttl: 60)
        cache.set(key: "home_section2", data: ["b": 2], ttl: 60)
        cache.set(key: "search_results", data: ["c": 3], ttl: 60)

        cache.invalidate(matching: "home_")

        XCTAssertNil(cache.get(key: "home_section1"))
        XCTAssertNil(cache.get(key: "home_section2"))
        XCTAssertNotNil(cache.get(key: "search_results"))
    }

    func testCacheEntryExpiration() async throws {
        // Set with a very short TTL
        cache.set(key: "short_lived", data: ["test": true], ttl: 0.1)

        // Should exist immediately
        XCTAssertNotNil(cache.get(key: "short_lived"))

        // Wait for expiration
        try await Task.sleep(for: .milliseconds(150))

        // Should be expired
        XCTAssertNil(cache.get(key: "short_lived"))
    }

    func testCacheOverwrite() {
        cache.set(key: "key", data: ["value": 1], ttl: 60)
        XCTAssertEqual(cache.get(key: "key")?["value"] as? Int, 1)

        cache.set(key: "key", data: ["value": 2], ttl: 60)
        XCTAssertEqual(cache.get(key: "key")?["value"] as? Int, 2)
    }

    func testCacheTTLConstants() {
        XCTAssertEqual(APICache.TTL.home, 5 * 60) // 5 minutes
        XCTAssertEqual(APICache.TTL.playlist, 30 * 60) // 30 minutes
        XCTAssertEqual(APICache.TTL.artist, 60 * 60) // 1 hour
        XCTAssertEqual(APICache.TTL.search, 2 * 60) // 2 minutes
        XCTAssertEqual(APICache.TTL.library, 5 * 60) // 5 minutes
        XCTAssertEqual(APICache.TTL.lyrics, 24 * 60 * 60) // 24 hours
        XCTAssertEqual(APICache.TTL.songMetadata, 30 * 60) // 30 minutes
    }

    func testLyricsCacheNotInvalidatedByMutations() {
        // Lyrics use browse: prefix but should NOT be invalidated by mutation operations
        // This test verifies that invalidating next: prefix doesn't affect lyrics
        cache.set(key: "browse:lyrics_abc123", data: ["text": "lyrics content"], ttl: APICache.TTL.lyrics)
        cache.set(key: "next:song_abc123", data: ["title": "song"], ttl: APICache.TTL.songMetadata)

        // Simulate mutation invalidation (like rateSong would do)
        cache.invalidate(matching: "next:")

        // Lyrics should still be cached (browse: prefix not invalidated)
        XCTAssertNotNil(cache.get(key: "browse:lyrics_abc123"))
        // Song metadata should be invalidated
        XCTAssertNil(cache.get(key: "next:song_abc123"))
    }

    func testSongMetadataCacheInvalidatedByMutations() {
        // Song metadata uses next: prefix and should be invalidated by mutations
        cache.set(key: "next:song_abc123", data: ["title": "song"], ttl: APICache.TTL.songMetadata)
        cache.set(key: "browse:home_section", data: ["section": "home"], ttl: APICache.TTL.home)

        // Simulate mutation invalidation for both prefixes
        cache.invalidate(matching: "browse:")
        cache.invalidate(matching: "next:")

        // Both should be invalidated
        XCTAssertNil(cache.get(key: "next:song_abc123"))
        XCTAssertNil(cache.get(key: "browse:home_section"))
    }

    func testCacheEntryIsExpired() {
        let freshEntry = APICache.CacheEntry(
            data: [:],
            timestamp: Date(),
            ttl: 60
        )
        XCTAssertFalse(freshEntry.isExpired)

        let expiredEntry = APICache.CacheEntry(
            data: [:],
            timestamp: Date().addingTimeInterval(-120),
            ttl: 60
        )
        XCTAssertTrue(expiredEntry.isExpired)
    }

    func testCacheSharedInstance() {
        XCTAssertNotNil(APICache.shared)
        // Test that it's truly a singleton
        let instance1 = APICache.shared
        let instance2 = APICache.shared
        XCTAssertTrue(instance1 === instance2)
    }
}
