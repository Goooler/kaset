import SwiftUI

// MARK: - FavoritesContextMenu

/// Shared context menu items for adding/removing items from Favorites.
@MainActor
enum FavoritesContextMenu {
    /// Creates a context menu button for toggling a song in/out of Favorites.
    @ViewBuilder
    static func menuItem(for song: Song, manager: FavoritesManager) -> some View {
        let isPinned = manager.isPinned(song: song)
        Button {
            manager.toggle(song: song)
        } label: {
            Label(
                isPinned ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isPinned ? "heart.slash" : "heart"
            )
        }
    }

    /// Creates a context menu button for toggling an album in/out of Favorites.
    @ViewBuilder
    static func menuItem(for album: Album, manager: FavoritesManager) -> some View {
        let isPinned = manager.isPinned(album: album)
        Button {
            manager.toggle(album: album)
        } label: {
            Label(
                isPinned ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isPinned ? "heart.slash" : "heart"
            )
        }
    }

    /// Creates a context menu button for toggling a playlist in/out of Favorites.
    @ViewBuilder
    static func menuItem(for playlist: Playlist, manager: FavoritesManager) -> some View {
        let isPinned = manager.isPinned(playlist: playlist)
        Button {
            manager.toggle(playlist: playlist)
        } label: {
            Label(
                isPinned ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isPinned ? "heart.slash" : "heart"
            )
        }
    }

    /// Creates a context menu button for toggling an artist in/out of Favorites.
    @ViewBuilder
    static func menuItem(for artist: Artist, manager: FavoritesManager) -> some View {
        let isPinned = manager.isPinned(artist: artist)
        Button {
            manager.toggle(artist: artist)
        } label: {
            Label(
                isPinned ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isPinned ? "heart.slash" : "heart"
            )
        }
    }

    /// Creates a context menu button for toggling a HomeSectionItem in/out of Favorites.
    @ViewBuilder
    static func menuItem(for item: HomeSectionItem, manager: FavoritesManager) -> some View {
        switch item {
        case .song(let song):
            Self.menuItem(for: song, manager: manager)
        case .album(let album):
            Self.menuItem(for: album, manager: manager)
        case .playlist(let playlist):
            Self.menuItem(for: playlist, manager: manager)
        case .artist(let artist):
            Self.menuItem(for: artist, manager: manager)
        }
    }

    /// Creates a context menu button for toggling a SearchResultItem in/out of Favorites.
    @ViewBuilder
    static func menuItem(for item: SearchResultItem, manager: FavoritesManager) -> some View {
        switch item {
        case .song(let song):
            Self.menuItem(for: song, manager: manager)
        case .album(let album):
            Self.menuItem(for: album, manager: manager)
        case .playlist(let playlist):
            Self.menuItem(for: playlist, manager: manager)
        case .artist(let artist):
            Self.menuItem(for: artist, manager: manager)
        }
    }
}
