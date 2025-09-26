compute_network_distances <- function(network, # road network
                                      origins_sf, # origins needs to be a sf object
                                      destinations_sf,  # destinations needs to be a sf object
                                      distance_colname = "distance_m",
                                      weight_col = "length" ) {
  library(sf)
  library(sfnetworks)
  library(tidygraph)
  library(nngeo)
  library(pbapply)
  library(shp2graph)
  
  # Ensure proper CRS
  crs_target <- st_crs(network)
  origins <- st_transform(origins_sf, crs = crs_target)
  destinations <- st_transform(destinations_sf, crs = crs_target)
  
  # Build sfnetwork with optional weight column
  net <- as_sfnetwork(network, directed = FALSE) %>%
    activate("edges")
  #mutate(weight = !!rlang::sym(weight_col))  # Assumes network has a 'length' or weight column
  
  # Extract nodes for snapping
  nodes_sf <- st_as_sf(net, "nodes")
  
  # Snap points to nearest network nodes
  origins$node <- st_nearest_feature(origins, nodes_sf)
  destinations$node <- st_nearest_feature(destinations, nodes_sf)
  
  origin_nodes <- origins$node
  destination_nodes <- unique(destinations$node)
  
  # Compute shortest path distances using weight
  g <- net %>% igraph::as.igraph()
  d <- distances(g, v = origin_nodes, to = destination_nodes, weights = E(g)$weight)
  
  # Find nearest destination and distance
  dist_vals <- pbapply(d, 1, min)
  nearest_destination_ids <- destination_nodes[apply(d, 1, which.min)]
  
  # Add result column (dynamic name)
  origins[[distance_colname]] <- dist_vals
  origins$nearest_destination_node <- nearest_destination_ids
  
  return(origins)
}
