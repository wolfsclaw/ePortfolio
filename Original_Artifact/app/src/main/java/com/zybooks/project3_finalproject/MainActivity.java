package com.zybooks.project3_finalproject;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    RecyclerView recyclerView;
    List<Item> itemList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = findViewById(R.id.recyclerView);

        initData();
        initRecyclerView();
    }

    private void initRecyclerView() {
        ItemAdapter itemAdapter = new ItemAdapter(itemList);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(itemAdapter);
    }

    private void initData() {
        itemList = new ArrayList<>();
        itemList.add(new Item(1, "Flour", "15", "Lbs."));
        itemList.add(new Item(2, "Sugar", "9", "Lbs."));
        itemList.add(new Item(3, "Butter", "12", "Lbs."));
        itemList.add(new Item(4, "Chocolate Chips", "7", "Lbs."));
        itemList.add(new Item(5, "Vanilla", "4", "Lbs."));
        itemList.add(new Item(6, "Baking Soda", "6", "Lbs."));
    }
}