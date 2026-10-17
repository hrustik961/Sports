using System;
using System.Collections.Generic;
using System.Data;
using Npgsql;
using Dapper;

namespace SportsEventApp
{
  // Models for active events and registrations
  public class ActiveEvent
  {
    public int EventId { get; set; }
    public string? EventTitle { get; set; }
    public DateTime EventDate { get; set; }
  }

  public class ActiveRegistration
  {
    public int RegistrationId { get; set; }
    public string? EventTitle { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? Status { get; set; }
  }

  // Repository interface for sports operations
  public interface ISportsRepository
  {
    IEnumerable<ActiveEvent> GetActiveEvents();
    IEnumerable<ActiveRegistration> GetActiveRegistrations();
    void RegisterAthlete(int eventId, int athleteId, int userId);
    void SoftDeleteEvent(int eventId, int userId);
  }

  public class SportsRepository : ISportsRepository
  {
    private readonly IDbConnection _connection;
    private readonly IDbTransaction _transaction;

    public SportsRepository(IDbConnection connection, IDbTransaction transaction)
    {
      _connection = connection;
      _transaction = transaction;
    }

    public IEnumerable<ActiveEvent> GetActiveEvents()
    {
      return _connection.Query<ActiveEvent>("SELECT * FROM vw_ActiveEvents", transaction: _transaction);
    }

    public IEnumerable<ActiveRegistration> GetActiveRegistrations()
    {
      return _connection.Query<ActiveRegistration>("SELECT * FROM vw_ActiveRegistrations", transaction: _transaction);
    }

    public void RegisterAthlete(int eventId, int athleteId, int userId)
    {
      _connection.Execute("CALL sp_RegisterAthlete(@EventId, @AthleteId, @UserId)",
          new { EventId = eventId, AthleteId = athleteId, UserId = userId },
          transaction: _transaction);
    }

    public void SoftDeleteEvent(int eventId, int userId)
    {
      _connection.Execute("CALL sp_SoftDeleteEvent(@EventId, @UserId)",
          new { EventId = eventId, UserId = userId },
          transaction: _transaction);
    }
  }

  // Unit of work interface
  public interface IUnitOfWork : IDisposable
  {
    ISportsRepository Sports { get; }
    void Commit();
  }

  public class UnitOfWork : IUnitOfWork
  {
    private readonly IDbConnection _connection;
    private IDbTransaction _transaction;
    private ISportsRepository _sportsRepository;

    public UnitOfWork(string connectionString)
    {
      _connection = new NpgsqlConnection(connectionString);
      _connection.Open();
      _transaction = _connection.BeginTransaction();
    }

    public ISportsRepository Sports => _sportsRepository ??= new SportsRepository(_connection, _transaction);

    public void Commit()
    {
      try
      {
        _transaction.Commit();
      }
      catch
      {
        _transaction.Rollback();
        throw;
      }
      finally
      {
        _transaction.Dispose();
        _transaction = _connection.BeginTransaction();
      }
    }

    public void Dispose()
    {
      _transaction?.Dispose();
      _connection?.Dispose();
    }
  }

  // Application entry point for demonstration
  class Program
  {
    static void Main(string[] args)
    {
      string connectionString = "Host=localhost;Port=5433;Database=sport_events;Username=postgres;Password=postgres;";

      using (IUnitOfWork uow = new UnitOfWork(connectionString))
      {
        Console.WriteLine(" Поточні активні події");
        var events = uow.Sports.GetActiveEvents();
        foreach (var e in events)
        {
          Console.WriteLine($"{e.EventId}: {e.EventTitle} ({e.EventDate})");
        }

        Console.WriteLine("\n Реєструємо спортсмена (Id=3) на подію (Id=1)");
        uow.Sports.RegisterAthlete(eventId: 1, athleteId: 3, userId: 1);

        uow.Commit();
        Console.WriteLine("Успішно збережено");

        Console.WriteLine("\n Активні реєстрації після оновлення");
        var registrations = uow.Sports.GetActiveRegistrations();
        foreach (var r in registrations)
        {
          Console.WriteLine($"{r.FirstName} {r.LastName} -> {r.EventTitle} [{r.Status}]");
        }
      }
    }
  }
}