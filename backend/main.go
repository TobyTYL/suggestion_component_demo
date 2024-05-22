package main

import (
	"context"
	"log"
	"net/http"

	"github.com/graphql-go/graphql"
	"github.com/graphql-go/handler"
	"github.com/rs/cors"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var client *mongo.Client

// Define the state type
var stateType = graphql.NewObject(graphql.ObjectConfig{
	Name: "State",
	Fields: graphql.Fields{
		"name": &graphql.Field{
			Type: graphql.String,
		},
	},
})

// Define the query type
var queryType = graphql.NewObject(graphql.ObjectConfig{
	Name: "Query",
	Fields: graphql.Fields{
		"states": &graphql.Field{
			Type: graphql.NewList(stateType),
			Args: graphql.FieldConfigArgument{
				"query": &graphql.ArgumentConfig{
					Type: graphql.String,
				},
			},
			Resolve: func(p graphql.ResolveParams) (interface{}, error) {
				query, _ := p.Args["query"].(string)
				return fetchStates(query)
			},
		},
	},
})

// Define the schema
var schema, _ = graphql.NewSchema(graphql.SchemaConfig{
	Query: queryType,
})

// Define the main function
func main() {
	// Connect to the MongoDB server
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")
	var err error
	client, err = mongo.Connect(context.Background(), clientOptions)
	if err != nil {
		log.Fatal(err)
	}
	err = client.Ping(context.Background(), nil)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Disconnect(context.Background())
	// Create a new instance of the default graphql handler
	graphqlHandler := handler.New(&handler.Config{
		Schema:   &schema,
		Pretty:   true,
		GraphiQL: true,
	})
	// Create a new instance of the default cors handler
	corsHandler := cors.Default().Handler(graphqlHandler)
	http.Handle("/graphql", corsHandler)
	log.Println("Server is running on port 8080")
	http.ListenAndServe(":8080", nil)
}

// Define the fetchStates function
func fetchStates(query string) ([]map[string]interface{}, error) {
	collection := client.Database("state_suggestion").Collection("states")
	//	Define the filter
	filter := bson.M{"name": bson.M{"$regex": query, "$options": "i"}}
	cur, err := collection.Find(context.Background(), filter)
	if err != nil {
		return nil, err
	}
	// Close the cursor once the function is done
	defer cur.Close(context.Background())
	var states []map[string]interface{}
	// Iterate through the result set
	for cur.Next(context.Background()) {
		var state map[string]interface{}
		err := cur.Decode(&state)
		if err != nil {
			return nil, err
		}
		states = append(states, state)
	}
	if err := cur.Err(); err != nil {
		return nil, err
	}

	return states, nil
}
