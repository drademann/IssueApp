import SwiftUI
import Combine

struct ProjectListView: View {
    
    @State private var requests = Set<AnyCancellable>()
    @State private var projects: [Project] = []
    
    var body: some View {
        List {
            ForEach(projects, id: \.key) { project in
                HStack {
                    Text(project.key)
                    Spacer()
                    Text(project.title)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Projects")
        .task { fetch() }
    }
    
    private func fetch() {
        let decoder = JSONDecoder()
        URLSession.shared.dataTaskPublisher(for: URL(string: "http://localhost:3000/api/projects")!)
            .map(\.data)
            .decode(type: [Project].self, decoder: decoder)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { projects in
                self.projects = projects
            }
            .store(in: &requests)
    }
}

#Preview {
    ProjectListView()
}
